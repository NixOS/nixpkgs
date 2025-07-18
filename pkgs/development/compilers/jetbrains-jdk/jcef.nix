{
  fetchFromGitHub,
  fetchurl,
  fetchzip,
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

  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  libGL,
  expat,
  libxcb,
  libxkbcommon,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libgbm,
  gtk3,
  pango,
  cairo,
  alsa-lib,
  dbus,
  at-spi2-core,
  cups,
  libxshmfence,
  udev,
  boost,
  thrift,
  darwin,
  apple-sdk_15,
}:

let
  rpath = lib.makeLibraryPath (
    [
      glib
      nss
      nspr
      atk
      at-spi2-atk
      expat
      libxcb
      libxkbcommon
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      gtk3
      pango
      cairo
      dbus
      at-spi2-core
      cups
      libxshmfence
    ]
    ++ lib.optionals stdenv.isLinux [
      libdrm
      libGL
      libgbm
      alsa-lib
      udev
    ]
  );

  buildType = if debugBuild then "Debug" else "Release";
  platform =
    {
      "aarch64-linux" = "linuxarm64";
      "x86_64-linux" = "linux64";
      "aarch64-darwin" = "macosarm64";
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
      "macosx64" = {
        depsArch = "universal";
        projectArch = "x86_64";
        targetArch = "x86_64";
      };
    }
    .${platform};
  inherit (arches) depsArch projectArch targetArch;

in
stdenv.mkDerivation rec {
  pname = "jcef-jetbrains";
  rev = "7a7b9383b3bf39c850feb0d103c6b829e2f48a6b";
  # This is the commit number
  # Currently from the branch: https://github.com/JetBrains/jcef/tree/251
  # Run `git rev-list --count HEAD`
  version = "1014";

  nativeBuildInputs =
    [
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
    ++ lib.optionals stdenv.isDarwin [
      darwin.xcode_16_1
    ];
  buildInputs =
    [
      boost
      libX11
      libXdamage
      nss
      nspr
      thrift
    ]
    ++ lib.optionals stdenv.isDarwin [
      apple-sdk_15
    ];

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jcef";
    inherit rev;
    hash = "sha256-ZMxx5mwmsBiUneULHFUDOrJQ8yKuK9bfPz89vN31ql4=";
  };
  cef-bin =
    let
      # `cef_binary_${CEF_VERSION}_linux64_minimal`, where CEF_VERSION is from $src/CMakeLists.txt
      name = "cef_binary_122.1.9+gd14e051+chromium-122.0.6261.94_${platform}_minimal";
      hash =
        {
          "linuxarm64" = "sha256-wABtvz0JHitlkkB748I7yr02Oxs5lXvqDfrBAQiKWHU=";
          "linux64" = "sha256-qlutM0IsE1emcMe/3p7kwMIK7ou1rZGvpUkrSMVPnCc=";
          "macosx64" = "sha256-BkG/duc49skqOLSgkKSNlsm4H6egUgNqBt8snJrc7MU=";
          "macosarm64" = "sha256-5WKGRDOrZqcVIWuPw4TIsoGwvSkyiOUzwHXXIDQnITs=";
        }
        .${platform};
      urlName = builtins.replaceStrings [ "+" ] [ "%2B" ] name;
    in
    fetchzip {
      url = "https://cef-builds.spotifycdn.com/${urlName}.tar.bz2";
      inherit name hash;
    };
  # Find the hash in tools/buildtools/${platform}/clang-format.sha1
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

  patchLibs =
    if stdenv.isDarwin then
      ''''
    else
      ''
        patchelf third_party/cef/${cef-bin.name}/${buildType}/libcef.so --set-rpath "${rpath}" --add-needed libudev.so
        patchelf third_party/cef/${cef-bin.name}/${buildType}/libGLESv2.so --set-rpath "${rpath}" --add-needed libGL.so.1
        patchelf third_party/cef/${cef-bin.name}/${buildType}/chrome-sandbox --set-interpreter $(cat $NIX_BINTOOLS/nix-support/dynamic-linker)
      '';

  configurePhase = ''
    runHook preConfigure

    patchShebangs .

    cp -r ${cef-bin} third_party/cef/${cef-bin.name}
    chmod +w -R third_party/cef/${cef-bin.name}
    ${patchLibs}

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

    sed -e 's|vcpkg_bring_host_thrift()|set(THRIFT_COMPILER_HOST ${thrift}/bin/thrift)|' -i remote/CMakeLists.txt

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
    "unpacked"
  ];

  postBuild = ''
    export JCEF_ROOT_DIR=$(realpath ..)
    ../tools/compile.sh ${platform} Release
  '';

  # N.B. For new versions, manually synchronize the following
  # definitions with jb/tools/common/create_modules.sh to include
  # newly added modules
  installPhase =
    ''
      runHook preInstall

      export JCEF_ROOT_DIR=$(realpath ..)
      export OUT_NATIVE_DIR=$JCEF_ROOT_DIR/jcef_build/native/${buildType}
      export JB_TOOLS_DIR=$(realpath ../jb/tools)
      export JB_TOOLS_OS_DIR=$JB_TOOLS_DIR/${toolFolder}
      export OUT_CLS_DIR=$(realpath ../out/${platform})
      export TARGET_ARCH=${targetArch} DEPS_ARCH=${depsArch}
      export OS=${os}
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
  };
}
