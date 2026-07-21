{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  lv2,
  libx11,
  liblo,
  libGL,
  libxcursor,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wolf-shaper";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "wolf-plugins";
    repo = "wolf-shaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4oi1wnex6eNRHUWXZHnvrmqp4veFuPJqD0YuOhDepg4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    lv2
    libx11
    liblo
    libGL
    libxcursor
  ];

  makeFlags = [
    "BUILD_LV2=true"
    "BUILD_DSSI=true"
    "BUILD_VST2=true"
    "BUILD_JACK=true"
  ];

  patchPhase = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mkdir -p $out/lib/dssi
    mkdir -p $out/lib/vst
    mkdir -p $out/bin/
    cp -r bin/wolf-shaper.lv2    $out/lib/lv2/
    cp -r bin/wolf-shaper-dssi*  $out/lib/dssi/
    cp -r bin/wolf-shaper-vst.so $out/lib/vst/
    cp -r bin/wolf-shaper        $out/bin/
  '';

  meta = {
    homepage = "https://wolf-plugins.github.io/wolf-shaper/";
    description = "Waveshaper plugin with spline-based graph editor";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "wolf-shaper";
  };
})
