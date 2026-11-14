{
  autoPatchelfHook,
  fetchFromGitHub,
  fetchurl,
  stdenv,
  cmake,
  python3,
  jdk,
  git,
  rsync,
  which,
  lib,
  ant,
  ninja,
  strip-nondeterminism,
  stripJavaArchivesHook,

  debugBuild ? false,

  nss,
  nspr,
  libGL,
  libx11,
  libxdamage,
  boost,
  thrift,
  cef-binary,
}:

let
  buildType = if debugBuild then "Debug" else "Release";
  platform =
    {
      "aarch64-linux" = "linuxarm64";
      "x86_64-linux" = "linux64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  arches =
    {
      "linuxarm64" = {
        depsArch = "arm64";
        projectArch = "arm64";
        targetArch = "arm64";
      };
      "linux64" = {
        depsArch = "amd64";
        projectArch = "x86_64";
        targetArch = "x86_64";
      };
    }
    .${platform};
  inherit (arches) depsArch projectArch targetArch;

  # `cef_binary_${CEF_VERSION}_linux64_minimal`, where CEF_VERSION is from $src/CMakeLists.txt
  cef-name = "cef_binary_150.0.14+g7c1aa68+chromium-150.0.7871.129_${platform}_minimal";

  cef-bin = cef-binary.override {
    version = "150.0.14";
    gitRevision = "7c1aa68";
    chromiumVersion = "150.0.7871.129";
    srcHashes = {
      aarch64-linux = "sha256-tA4hWg9G/UDQSxXUuDO+IRjvc8Qx1cEdGOtiXg3ktk0=";
      x86_64-linux = "sha256-QO9hPkVcrNB6p8gfQl76qLb3frg/E8wo1HDuuk5h+Y8=";
    };
  };

  thrift23 = thrift.overrideAttrs (old: {
    version = "0.23.0";

    src = fetchFromGitHub {
      owner = "apache";
      repo = "thrift";
      tag = "v0.23.0";
      hash = "sha256-7N9jLDwvw6xh8uUY13Mmw6KEaNLYVowudrYSL2yJj2Q=";
    };

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
    ];
  });

in
stdenv.mkDerivation rec {
  pname = "jcef-jetbrains";
  rev = "5a9c64ca090f24d1d037de7b3edca2ee5607c995";
  # This is the commit number
  # Currently from the branch: https://github.com/JetBrains/jcef/tree/263
  # Run `git rev-list --count HEAD`
  version = "1231";

  nativeBuildInputs = [
    cmake
    python3
    jdk
    git
    rsync
    which
    ant
    ninja
    strip-nondeterminism
    stripJavaArchivesHook
    autoPatchelfHook
  ];

  buildInputs = [
    boost
    libGL
    libx11
    libxdamage
    nss
    nspr
    thrift23
  ];

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jcef";
    inherit rev;
    hash = "sha256-Q4LQnzbUiAGyWgsfCuMayj76FzC4bN0l1O90vP96IGM=";
  };

  # Find the hash in tools/buildtools/linux64/clang-format.sha1
  clang-fmt = fetchurl {
    url = "https://storage.googleapis.com/chromium-clang-format/dd736afb28430c9782750fc0fd5f0ed497399263";
    hash = "sha256-4H6FVO9jdZtxH40CSfS+4VESAHgYgYxfCBFSMHdT0hE=";
  };

  configurePhase = ''
    runHook preConfigure

    patchShebangs .

    cp -r ${cef-bin} third_party/cef/${cef-name}
    chmod +w -R third_party/cef/${cef-name}

    sed \
      -e 's|os.path.isdir(os.path.join(path, \x27.git\x27))|True|' \
      -e 's|"%s rev-parse %s" % (git_exe, branch)|"echo '${rev}'"|' \
      -e 's|"%s config --get remote.origin.url" % git_exe|"echo 'https://github.com/jetbrains/jcef'"|' \
      -e 's|"%s rev-list --count %s" % (git_exe, branch)|"echo '${version}'"|' \
      -i tools/git_util.py

    cp ${clang-fmt} tools/buildtools/linux64/clang-format
    chmod +w tools/buildtools/linux64/clang-format

    sed \
      -e 's|include(cmake/vcpkg.cmake)||' \
      -e 's|bring_vcpkg()||' \
      -e 's|vcpkg_install_package(boost-filesystem boost-interprocess thrift)||' \
      -i CMakeLists.txt

    sed -e 's|vcpkg_bring_host_thrift()|set(THRIFT_COMPILER_HOST ${lib.getExe thrift23})|' -i remote/CMakeLists.txt

    mkdir jcef_build
    cd jcef_build

    cmake -G "Ninja" -DPROJECT_ARCH="${projectArch}" -DCMAKE_BUILD_TYPE=${buildType} ..

    runHook postConfigure
  '';

  outputs = [
    "out"
  ];

  postBuild = ''
    export JCEF_ROOT_DIR=$(realpath ..)

    ../tools/compile.sh ${platform} Release
  '';

  installPhase = ''
    runHook preInstall

    export JCEF_ROOT_DIR=$(realpath ..)
    export OUT_NATIVE_DIR=$JCEF_ROOT_DIR/jcef_build/native/${buildType}
    export OUT_REMOTE_DIR=$JCEF_ROOT_DIR/jcef_build/remote/${buildType}
    export JB_TOOLS_DIR=$(realpath ../jb/tools)
    export JB_TOOLS_OS_DIR=$JB_TOOLS_DIR/linux
    export OUT_CLS_DIR=$(realpath ../out/${platform})
    export TARGET_ARCH=${targetArch} DEPS_ARCH=${depsArch}
    export OS=linux
    export JOGAMP_DIR="$JCEF_ROOT_DIR"/third_party/jogamp/jar

    bash "$JB_TOOLS_DIR"/common/create_modules.sh

    mkdir -p $out

    bash "$JB_TOOLS_DIR"/common/create_version_file.sh $out

    cp -r $JCEF_ROOT_DIR/jmods/ $out
    cp -r $JCEF_ROOT_DIR/cef_server/ $out

    runHook postInstall
  '';

  dontStrip = debugBuild;

  postFixup = ''
    # stripJavaArchivesHook gets rid of jar file timestamps, but not of jmod file timestamps
    # We have to manually call strip-nondeterminism to do this for jmod files too
    find $out -name "*.jmod" -exec strip-nondeterminism --type jmod {} +
  '';

  meta = {
    description = "Jetbrains' fork of JCEF";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/JetBrains/JCEF";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      aoli-al
    ];
  };
}
