{
  fetchFromGitHub,
  fetchurl,
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
  libX11,
  libXdamage,
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
  cef-name = "cef_binary_137.0.17+gf354b0e+chromium-137.0.7151.104_${platform}_minimal";

  cef-bin = cef-binary.override {
    version = "137.0.17"; # follow upstream. https://github.com/Almamu/linux-wallpaperengine/blob/b39f12757908eda9f4c1039613b914606568bb84/CMakeLists.txt#L47
    gitRevision = "f354b0e";
    chromiumVersion = "137.0.7151.104";
    srcHashes = {
      aarch64-linux = "sha256-C9P4+TpzjyMD5z2qLbzubbrIr66usFjRx7QqiAxI2D8=";
      x86_64-linux = "sha256-iDC3a/YN0NqjX/b2waKvUAZCaR0lkLmUPqBJphE037Q=";
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
  });

in
stdenv.mkDerivation rec {
  pname = "jcef-jetbrains";
  rev = "bb9fb310ed7f3abf858faf248c53bbb707be21f7";
  # This is the commit number
  # Currently from the branch: https://github.com/JetBrains/jcef/tree/251
  # Run `git rev-list --count HEAD`
  version = "1083";

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
  ];
  buildInputs = [
    boost
    libX11
    libXdamage
    nss
    nspr
    thrift20
  ];

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jcef";
    inherit rev;
    hash = "sha256-BHmGEhfkrUWDfrUFR8d5AgIq8qkAr+blX9n7ZVg8mtc=";
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

    sed -e 's|vcpkg_bring_host_thrift()|set(THRIFT_COMPILER_HOST ${lib.getExe thrift20})|' -i remote/CMakeLists.txt

    mkdir jcef_build
    cd jcef_build

    cmake -G "Ninja" -DPROJECT_ARCH="${projectArch}" -DCMAKE_BUILD_TYPE=${buildType} ..

    runHook postConfigure
  '';

  outputs = [
    "out"
    "unpacked"
  ];

  postBuild = ''
    export JCEF_ROOT_DIR=$(realpath ..)
    ../tools/compile.sh ${platform} Release
  '';

  # N.B. For new versions, manually synchronize the following
  # definitions with jb/tools/common/create_modules.sh to include
  # newly added modules
  installPhase = ''
    runHook preInstall

    export JCEF_ROOT_DIR=$(realpath ..)
    export OUT_NATIVE_DIR=$JCEF_ROOT_DIR/jcef_build/native/${buildType}
    export JB_TOOLS_DIR=$(realpath ../jb/tools)
    export JB_TOOLS_OS_DIR=$JB_TOOLS_DIR/linux
    export OUT_CLS_DIR=$(realpath ../out/${platform})
    export TARGET_ARCH=${targetArch} DEPS_ARCH=${depsArch}
    export OS=linux
    export JOGAMP_DIR="$JCEF_ROOT_DIR"/third_party/jogamp/jar

    mkdir -p $unpacked/{jogl,gluegen,jcef}

    function extract_jar {
      __jar=$1
      __dst_dir=$2
      __content_dir="''${3:-.}"
      __tmp=.tmp_extract_jar
      rm -rf "$__tmp" && mkdir "$__tmp"
      (
        cd "$__tmp" || exit 1
        jar -xf "$__jar"
      )
      rm -rf "$__tmp/META-INF"
      rm -rf "$__dst_dir" && mkdir "$__dst_dir"
      if [ -z "$__content_dir" ]
      then
          cp -R "$__tmp"/* "$__dst_dir"
      else
          cp -R "$__tmp"/"$__content_dir"/* "$__dst_dir"
      fi
      rm -rf $__tmp
    }

    cd $unpacked/gluegen
    cp "$JOGAMP_DIR"/gluegen-rt.jar .
    cp "$JB_TOOLS_DIR"/common/gluegen-module-info.java module-info.java
    javac --patch-module gluegen.rt=gluegen-rt.jar module-info.java
    jar uf gluegen-rt.jar module-info.class
    rm module-info.class module-info.java
    mkdir lib
  ''
  # see https://github.com/JetBrains/jcef/commit/f3b787e3326c1915d663abded7f055c0866f32ec
  + lib.optionalString (platform != "linuxarm64") ''
    extract_jar "$JOGAMP_DIR"/gluegen-rt-natives-"$OS"-"$DEPS_ARCH".jar lib natives/"$OS"-"$DEPS_ARCH"
  ''
  + ''

    cd ../jogl
    cp "$JOGAMP_DIR"/gluegen-rt.jar .
    cp "$JOGAMP_DIR"/jogl-all.jar .
    cp "$JB_TOOLS_OS_DIR"/jogl-module-info.java module-info.java
    javac --module-path . --patch-module jogl.all=jogl-all.jar module-info.java
    jar uf jogl-all.jar module-info.class
    rm module-info.class module-info.java
    mkdir lib
  ''
  # see https://github.com/JetBrains/jcef/commit/f3b787e3326c1915d663abded7f055c0866f32ec
  + lib.optionalString (platform != "linuxarm64") ''
    extract_jar "$JOGAMP_DIR"/jogl-all-natives-"$OS"-"$DEPS_ARCH".jar lib natives/"$OS"-"$DEPS_ARCH"
  ''
  + ''

    cd ../jcef
    cp "$OUT_CLS_DIR"/jcef.jar .
    mkdir lib
    cp -R "$OUT_NATIVE_DIR"/* lib

    mkdir -p $out/jmods

    bash "$JB_TOOLS_DIR"/common/create_version_file.sh $out

    runHook postInstall
  '';

  dontStrip = debugBuild;

  postFixup = ''
    cd $unpacked/gluegen
    jmod create --class-path gluegen-rt.jar --libs lib $out/jmods/gluegen.rt.jmod
    cd ../jogl
    jmod create --module-path . --class-path jogl-all.jar --libs lib $out/jmods/jogl.all.jmod
    cd ../jcef
    jmod create --module-path . --class-path jcef.jar --libs lib $out/jmods/jcef.jmod

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
  };
}
