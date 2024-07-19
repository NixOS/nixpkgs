{ stdenv, lib, pkgs, fetchFromGitHub, writeText, openjdk11_headless, gradle_6
, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib
, ffmpeg_4-headless, python3, ruby
, withMedia ? true
, withWebKit ? false
}:

let
  pname = "openjfx-modular-sdk";
  major = "15";
  update = ".0.1";
  build = "+1";
  repover = "${major}${update}${build}";
  jdk = openjdk11_headless;
  gradle = gradle_6;

in stdenv.mkDerivation {
  inherit pname;
  version = "${major}${update}${build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jfx";
    rev = repover;
    sha256 = "019glq8rhn6amy3n5jc17vi2wpf1pxpmmywvyz1ga8n09w7xscq1";
  };

  buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless ];
  nativeBuildInputs = [ gradle perl pkg-config cmake gperf python3 ruby ];

  dontUseCmakeConfigure = true;

  config = writeText "gradle.properties" ''
    CONF = Release
    JDK_HOME = ${jdk.home}
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
  '';

  postPatch = ''
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
    # avoids errors about deprecation of GTypeDebugFlags, GTimeVal, etc.
    export NIX_CFLAGS_COMPILE="-DGLIB_DISABLE_DEPRECATION_WARNINGS $NIX_CFLAGS_COMPILE"
    # gstreamer workaround for -fno-common toolchains:
    #   ld: gsttypefindelement.o:(.bss._gst_disable_registry_cache+0x0): multiple definition of
    #     `_gst_disable_registry_cache'; gst.o:(.bss._gst_disable_registry_cache+0x0): first defined here
    export NIX_CFLAGS_COMPILE="-fcommon $NIX_CFLAGS_COMPILE"
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
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "Next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    knownVulnerabilities = [
      "This OpenJFX version has reached its end of life."
    ];
    platforms = [ "x86_64-linux" ];
  };
}
