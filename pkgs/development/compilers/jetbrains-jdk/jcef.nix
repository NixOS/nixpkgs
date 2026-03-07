{
  autoPatchelfHook,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  stdenv,
  cmake,
  python3,
  jdk,
  git,
  rsync,
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
  darwin,
  apple-sdk,
}:

let
  buildType = if debugBuild then "Debug" else "Release";
  platform =
    {
      "aarch64-linux" = "linuxarm64";
      "x86_64-linux" = "linux64";
      "aarch64-darwin" = "macosarm64";
      #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
      "x86_64-darwin" = "macosx64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  arches =
    {
      "linuxarm64" = {
        depsArch = "arm64";
        projectArch = "arm64";
        targetArch = "arm64";
      };
      "macosarm64" = {
        depsArch = "universal";
        projectArch = "arm64";
        targetArch = "arm64";
      };
      "linux64" = {
        depsArch = "amd64";
        projectArch = "x86_64";
        targetArch = "x86_64";
      };
      #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
      "macosx64" = {
        depsArch = "universal";
        projectArch = "x86_64";
        targetArch = "x86_64";
      };
    }
    .${platform};
  inherit (arches) depsArch projectArch targetArch;

  # `cef_binary_${CEF_VERSION}_linux64_minimal`, where CEF_VERSION is from $src/CMakeLists.txt
  cef-name = "cef_binary_137.0.17+gf354b0e+chromium-137.0.7151.104_${platform}_minimal";

  cef-bin = cef-binary.override {
    version = "137.0.17"; # follow upstream. https://github.com/Almamu/linux-wallpaperengine/blob/b39f12757908eda9f4c1039613b914606568bb84/CMakeLists.txt#L47
    gitRevision = "f354b0e";
    chromiumVersion = "137.0.7151.104";
    srcHashes = {
      aarch64-linux = "sha256-C9P4+TpzjyMD5z2qLbzubbrIr66usFjRx7QqiAxI2D8=";
      aarch64-darwin = "sha256-rKXorqz0KxpwRjq2rf6eJiCzkgJe+9+Vfa0eG2dDSQQ=";
      x86_64-linux = "sha256-iDC3a/YN0NqjX/b2waKvUAZCaR0lkLmUPqBJphE037Q=";
      #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
      x86_64-darwin = "sha256-BkG/duc49skqOLSgkKSNlsm4H6egUgNqBt8snJrc7MU=";
    };
  };

  thrift20 = thrift.overrideAttrs (old: {
    version = "0.20.0";

    src = fetchFromGitHub {
      owner = "apache";
      repo = "thrift";
      tag = "v0.20.0";
      hash = "sha256-cwFTcaNHq8/JJcQxWSelwAGOLvZHoMmjGV3HBumgcWo=";
    };

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
    ];
    patches = (old.patches or [ ]) ++ [
      # Fix build with gcc15
      # https://github.com/apache/thrift/pull/3078
      (fetchpatch {
        name = "thrift-add-missing-cstdint-include-gcc15.patch";
        url = "https://github.com/apache/thrift/commit/947ad66940cfbadd9b24ba31d892dfc1142dd330.patch";
        hash = "sha256-pWcG6/BepUwc/K6cBs+6d74AWIhZ2/wXvCunb/KyB0s=";
      })
    ];
  });

in
stdenv.mkDerivation rec {
  pname = "jcef-jetbrains";
  rev = "6f9ab690b28a1262f82e6f869c310bdf1d0697ac";
  # This is the commit number
  # Currently from the branch: https://github.com/JetBrains/jcef/tree/251
  # Run `git rev-list --count HEAD`
  version = "1086";

  nativeBuildInputs = [
    cmake
    python3
    jdk
    git
    rsync
    ant
    ninja
    strip-nondeterminism
    stripJavaArchivesHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.xcode_16_1
  ];
  buildInputs = [
    boost
    libGL
    libx11
    libxdamage
    nss
    nspr
    thrift20
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
  ];

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jcef";
    inherit rev;
    hash = "sha256-w5t1M66KW5cUbNTpAc4ksGd+414EJsXwbq1UP1COFsw=";
  };

  clang-fmt =
    let
      platformInfo =
        {
          "linuxarm64" = {
            key = "dd736afb28430c9782750fc0fd5f0ed497399263";
            hash = "sha256-4H6FVO9jdZtxH40CSfS+4VESAHgYgYxfCBFSMHdT0hE=";
          };
          "linux64" = {
            key = "dd736afb28430c9782750fc0fd5f0ed497399263";
            hash = "sha256-4H6FVO9jdZtxH40CSfS+4VESAHgYgYxfCBFSMHdT0hE=";
          };
          #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
          "macosx64" = {
            key = "a1b33be85faf2578f3101d7806e443e1c0949498";
            hash = "sha256-RscqWe309rwQe1vEoefAP+fHxx5KAtvQA0Zh3lj62pc=";
          };
          "macosarm64" = {
            key = "f1424c44ee758922823d6b37de43705955c99d7e";
            hash = "sha256-m+qCYEZUmCgU37JTlEVdyYml4T/rA3Lt/vJh7/ToSlo=";
          };
        }
        .${platform};
    in
    fetchurl {
      url = "https://storage.googleapis.com/chromium-clang-format/${platformInfo.key}";
      hash = platformInfo.hash;
    };

  clangFmtFolder = if stdenv.isDarwin then "mac" else "linux64";
  os = if stdenv.isDarwin then "macosx" else "linux";
  toolFolder = if stdenv.isDarwin then "mac" else "linux";

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

    cp ${clang-fmt} tools/buildtools/${clangFmtFolder}/clang-format
    chmod +w tools/buildtools/${clangFmtFolder}/clang-format

    sed \
      -e 's|include(cmake/vcpkg.cmake)||' \
      -e 's|bring_vcpkg()||' \
      -e 's|vcpkg_install_package(boost-filesystem boost-interprocess thrift)||' \
      -i CMakeLists.txt

    sed -e 's|vcpkg_bring_host_thrift()|set(THRIFT_COMPILER_HOST ${lib.getExe thrift20})|' -i remote/CMakeLists.txt

    # Remove runtime for appbundler because it only recognizes MacOS style Java home paths
    # https://github.com/ome/appbundler/blob/6f153a3706960e3568a6815c27f5cd02cb36f654/appbundler/src/com/oracle/appbundler/AppBundlerTask.java#L629
    sed -e 's|<runtime dir="''${env.JAVA_HOME}"/>||' -i build.xml

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
    export JB_TOOLS_OS_DIR=$JB_TOOLS_DIR/${toolFolder}
    export OUT_CLS_DIR=$(realpath ../out/${platform})
    export TARGET_ARCH=${targetArch} DEPS_ARCH=${depsArch}
    export OS=${os}
    export JOGAMP_DIR="$JCEF_ROOT_DIR"/third_party/jogamp/jar

    bash "$JB_TOOLS_DIR"/common/create_modules.sh

    mkdir -p $out

    bash "$JB_TOOLS_DIR"/common/create_version_file.sh $out

    cp -r $JCEF_ROOT_DIR/jmods/ $out
    ${if stdenv.isLinux then "cp -r $JCEF_ROOT_DIR/cef_server/ $out" else ""}

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
    platforms = lib.platforms.darwin ++ [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      aoli-al
      eveeifyeve # Darwin
    ];
  };
}
