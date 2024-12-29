{ stdenv, lib, pkgs, fetchFromGitHub, fetchpatch, writeText
, openjdk19_headless, gradle_7, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst
, libXxf86vm, glib, alsa-lib, ffmpeg_4, python3, ruby
, withMedia ? true
, withWebKit ? false
}:

let
  pname = "openjfx-modular-sdk";
  major = "19";
  update = ".0.2.1";
  build = "+1";
  repover = "${major}${update}${build}";
  jdk = openjdk19_headless;
  gradle = gradle_7;

in stdenv.mkDerivation {
  inherit pname;
  version = "${major}${update}${build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jfx";
    rev = repover;
    hash = "sha256-A08GhCGpzWlUG1+f6mcjvkJmMNaOReacQKPEmNpUvLs=";
  };

  patches = [
    # 8295962: Reference to State in Task.java is ambiguous when building with JDK 19
    (fetchpatch {
      url = "https://github.com/openjdk/jfx/pull/933/commits/cfaee2a52350eff39dd4352484c892716076d3de.patch";
      hash = "sha256-hzJMenhvtmHs/6BJj8GfaLp14myV8VCXCLLC8n32yEw=";
    })
    # ditto
    (fetchpatch {
      url = "https://github.com/openjdk/jfx/pull/933/commits/bd46ce12df0a93a56fe0d58d3653d08e58409b7f.patch";
      hash = "sha256-o9908uw9vYvULmAh/lbfyHhgxz6jpgPq2fcAltWsYoU=";
    })
  ];

  buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4 ];
  nativeBuildInputs = [ gradle perl pkg-config cmake gperf python3 ruby ];

  dontUseCmakeConfigure = true;

  config = writeText "gradle.properties" ''
    CONF = Release
    JDK_HOME = ${jdk.home}
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
  '';

  postPatch = ''
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
  '';

  disallowedReferences = [ jdk gradle.jdk ];

  meta = with lib; {
    homepage = "https://openjdk.org/projects/openjfx/";
    license = licenses.gpl2Classpath;
    description = "Next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
    knownVulnerabilities = [
      "This OpenJFX version has reached its end of life."
    ];
  };
}
