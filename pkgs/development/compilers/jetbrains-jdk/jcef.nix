{ fetchFromGitHub
, fetchurl
, fetchzip
, stdenv
, cmake
, python3
, jdk17
, git
, libcef
, rsync
, lib
, ant
, ninja

, debugBuild ? false

, glib
, nss
, nspr
, atk
, at-spi2-atk
, libdrm
, expat
, libxcb
, libxkbcommon
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, mesa
, gtk3
, pango
, cairo
, alsa-lib
, dbus
, at-spi2-core
, cups
, libxshmfence
, udev
}:

assert !stdenv.isDarwin;
# I can't test darwin

let rpath = lib.makeLibraryPath [
  glib
  nss
  nspr
  atk
  at-spi2-atk
  libdrm
  expat
  libxcb
  libxkbcommon
  libX11
  libXcomposite
  libXdamage
  libXext
  libXfixes
  libXrandr
  mesa
  gtk3
  pango
  cairo
  alsa-lib
  dbus
  at-spi2-core
  cups
  libxshmfence
  udev
];

buildType = if debugBuild then "Debug" else "Release";

in stdenv.mkDerivation rec {
  pname = "jcef-jetbrains";
  rev = "1ac1c682c497f2b864f86050796461f22935ea64";
  # This is the commit number
  # Currently from the branch: https://github.com/JetBrains/jcef/tree/232
  # Run `git rev-list --count HEAD`
  version = "672";

  nativeBuildInputs = [ cmake python3 jdk17 git rsync ant ninja ];
  buildInputs = [ libX11 libXdamage nss nspr ];

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jcef";
    inherit rev;
    hash = "sha256-3HuW8upR/bZoK8euVti2KpCZh9xxfqgyHmgoG1NjxOI=";
  };
  cef-bin = let
    fileName = "cef_binary_111.2.1+g870da30+chromium-111.0.5563.64_linux64_minimal";
    urlName = builtins.replaceStrings ["+"] ["%2B"] fileName;
  in fetchzip rec {
    name = fileName;
    url = "https://cef-builds.spotifycdn.com/${urlName}.tar.bz2";
    hash = "sha256-r+zXTmDN5s/bYLvbCnHufYdXIqQmCDlbWgs5pdOpLTw=";
  };
  clang-fmt = fetchurl {
    url = "https://storage.googleapis.com/chromium-clang-format/dd736afb28430c9782750fc0fd5f0ed497399263";
    hash = "sha256-4H6FVO9jdZtxH40CSfS+4VESAHgYgYxfCBFSMHdT0hE=";
  };

  configurePhase = ''
    runHook preConfigure

    patchShebangs .

    cp -r ${cef-bin} third_party/cef/${cef-bin.name}
    chmod +w -R third_party/cef/${cef-bin.name}
    patchelf third_party/cef/${cef-bin.name}/${buildType}/libcef.so --set-rpath "${rpath}" --add-needed libudev.so
    patchelf third_party/cef/${cef-bin.name}/${buildType}/chrome-sandbox --set-interpreter $(cat $NIX_BINTOOLS/nix-support/dynamic-linker)
    sed 's/-O0/-O2/' -i third_party/cef/${cef-bin.name}/cmake/cef_variables.cmake

    sed \
      -e 's|os.path.isdir(os.path.join(path, \x27.git\x27))|True|' \
      -e 's|"%s rev-parse %s" % (git_exe, branch)|"echo '${rev}'"|' \
      -e 's|"%s config --get remote.origin.url" % git_exe|"echo 'https://github.com/jetbrains/jcef'"|' \
      -e 's|"%s rev-list --count %s" % (git_exe, branch)|"echo '${version}'"|' \
      -i tools/git_util.py

    cp ${clang-fmt} tools/buildtools/linux64/clang-format
    chmod +w tools/buildtools/linux64/clang-format

    mkdir jcef_build
    cd jcef_build

    cmake -G "Ninja" -DPROJECT_ARCH="x86_64" -DCMAKE_BUILD_TYPE=${buildType} ..

    runHook postConfigure
  '';

  outputs = [ "out" "unpacked" ];

  postBuild = ''
    export JCEF_ROOT_DIR=$(realpath ..)
    ../tools/compile.sh linux64 Release
  '';

  # Mostly taken from jb/tools/common/create_modules.sh
  installPhase = ''
    runHook preInstall

    export JCEF_ROOT_DIR=$(realpath ..)
    export OUT_NATIVE_DIR=$JCEF_ROOT_DIR/jcef_build/native/${buildType}
    export JB_TOOLS_DIR=$(realpath ../jb/tools)
    export JB_TOOLS_OS_DIR=$JB_TOOLS_DIR/linux
    export OUT_CLS_DIR=$(realpath ../out/linux64)
    export TARGET_ARCH=x86_64 DEPS_ARCH=amd64
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
    extract_jar "$JOGAMP_DIR"/gluegen-rt-natives-"$OS"-"$DEPS_ARCH".jar lib natives/"$OS"-"$DEPS_ARCH"

    cd ../jogl
    cp "$JOGAMP_DIR"/gluegen-rt.jar .
    cp "$JOGAMP_DIR"/jogl-all.jar .
    cp "$JB_TOOLS_OS_DIR"/jogl-module-info.java module-info.java
    javac --module-path . --patch-module jogl.all=jogl-all.jar module-info.java
    jar uf jogl-all.jar module-info.class
    rm module-info.class module-info.java
    mkdir lib
    extract_jar "$JOGAMP_DIR"/jogl-all-natives-"$OS"-"$DEPS_ARCH".jar lib natives/"$OS"-"$DEPS_ARCH"

    cd ../jcef
    cp "$OUT_CLS_DIR"/jcef.jar .
    mkdir lib
    cp -R "$OUT_NATIVE_DIR"/* lib

    mkdir $out

    runHook postInstall
  '';

  dontStrip = debugBuild;

  postFixup = ''
    cd $unpacked/gluegen
    jmod create --class-path gluegen-rt.jar --libs lib $out/gluegen.rt.jmod
    cd ../jogl
    jmod create --module-path . --class-path jogl-all.jar --libs lib $out/jogl.all.jmod
    cd ../jcef
    jmod create --module-path . --class-path jcef.jar --libs lib $out/jcef.jmod
  '';

  meta = {
    description = "Jetbrains' fork of JCEF";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/JetBrains/JCEF";
  };
}
