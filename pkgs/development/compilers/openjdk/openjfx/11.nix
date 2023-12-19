{ stdenv, lib, fetchFromGitHub, writeText, gradle_7, pkg-config, perl, cmake
, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib, ffmpeg_4-headless, python3, ruby, icu68
, openjdk11-bootstrap
, withMedia ? true
, withWebKit ? false
}:

let
  pname = "openjfx-modular-sdk";
  major = "11";
  update = ".0.18";
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
    sha256 = "sha256-46DjIzcBHkmp5vnhYnLu78CG72bIBRM4A6mgk2OLOko=";
  };

  buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless icu68 ];
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

    ln -s $config gradle.properties
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps${major}.json;
  };

  preBuild = ''
    export NUMBER_OF_PROCESSORS=$NIX_BUILD_CORES
    export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
  '';

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" ];

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

  passthru.updateDeps = gradle.updateDeps {
    attrPath = "openjfx${major}.override { withWebKit = true; }";
    depsPath = "deps${major}.json";
    availablePackages = [
      "pkg-config"
      "glib" "gtk2" "gtk3" "xorg.libXtst"
    ];
  };

  meta = with lib; {
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "The next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" ];
  };
}
