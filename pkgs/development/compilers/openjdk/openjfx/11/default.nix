{ stdenv, lib, pkgs, fetchFromGitHub, writeText, gradle_7, pkg-config, perl, cmake
, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib, ffmpeg_7-headless, python3, ruby
, openjdk11-bootstrap
, withMedia ? true
, withWebKit ? false
}:

let
  pname = "openjfx-modular-sdk";
  major = "11";
  update = ".0.20";
  build = "1";
  repover = "${major}${update}+${build}";
  jdk = openjdk11-bootstrap;
  gradle = gradle_7;

in stdenv.mkDerivation {
  inherit pname;
  version = "${major}${update}-${build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jfx${major}u";
    rev = repover;
    sha256 = "sha256-BbBP2DiPZTSn1SBYMCgyiNdF9GD+NqR6YjeVNOQHHn4=";
  };

  patches = [
    ../backport-ffmpeg-6-support-jfx11.patch
    ../backport-ffmpeg-7-support-jfx11.patch
  ];

  buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_7-headless ];
  nativeBuildInputs = [ gradle perl pkg-config cmake gperf python3 ruby ];

  dontUseCmakeConfigure = true;

  config = writeText "gradle.properties" ''
    CONF = Release
    JDK_HOME = ${jdk.home}
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
  '';

  postPatch = ''
    substituteInPlace buildSrc/linux.gradle \
      --replace ', "-Werror=implicit-function-declaration"' ""

    # Add missing includes for gcc-13 for webkit build:
    sed -e '1i #include <cstdio>' \
      -i modules/javafx.web/src/main/native/Source/bmalloc/bmalloc/Heap.cpp \
         modules/javafx.web/src/main/native/Source/bmalloc/bmalloc/IsoSharedPageInlines.h

    ln -s $config gradle.properties
  '';

  mitmCache = gradle.fetchDeps {
    attrPath = "openjfx${major}";
    pkg = pkgs."openjfx${major}".override { withWebKit = true; };
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  preBuild = ''
    export NUMBER_OF_PROCESSORS=$NIX_BUILD_CORES
    export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
  '';

  enableParallelBuilding = false;

  gradleBuildTask = "sdk";

  installPhase = ''
    cp -r build/modular-sdk $out
  '';

  stripDebugList = [ "." ];

  postFixup = ''
    # Remove references to bootstrap.
    export openjdkOutPath='${jdk.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
    # Remove licenses, otherwise they may conflict with the ones included in the openjdk
    rm -rf $out/modules_legal/*
  '';

  disallowedReferences = [ jdk gradle.jdk ];

  # Uses a lot of RAM, OOMs otherwise
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "Next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" ];
  };
}
