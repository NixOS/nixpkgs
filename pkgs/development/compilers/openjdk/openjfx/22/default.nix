{ stdenv
, lib
, pkgs
, fetchFromGitHub
, fetchpatch2
, writeText
, openjdk21_headless
, gradle
, pkg-config
, perl
, cmake
, gperf
, gtk2
, gtk3
, libXtst
, libXxf86vm
, glib
, alsa-lib
, ffmpeg_7
, python3
, ruby
, withMedia ? true
, withWebKit ? false
}:

let
  pname = "openjfx-modular-sdk";
  major = "22";
  update = ".0.2";
  build = "-ga";
  repover = "${major}${update}${build}";
  jdk = openjdk21_headless;

in stdenv.mkDerivation {
  inherit pname;
  version = "${major}${update}${build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jfx22u";
    rev = repover;
    hash = "sha256-7Q9nZ2p3KfQPt1A2ULwk64OU/5/ghEkcsf9ECD6Ln2g=";
  };

  patches = [
    # 8338701: Provide media support for libavcodec version 61
    # <https://github.com/openjdk/jfx/pull/1552>
    (fetchpatch2 {
      url = "https://github.com/openjdk/jfx/commit/6115b396bacf62f39dcaa93c7c0adcd60b428b8c.patch?full_index=1";
      hash = "sha256-6EES4qsumFgXePZSDEetJC1Li65zquz3UjwRbq/6YJM=";
    })
  ];

  buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_7 ];
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
  };
}
