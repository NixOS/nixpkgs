{
  lib,
  stdenv,
  fetchFromGitHub,
  ladspa-sdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tap-plugins";
  version = "unstable-2020-12-09";

  src = fetchFromGitHub {
    owner = "tomscii";
    repo = "tap-plugins";
    rev = "5d882799f37dffe37fc73451f2c5b4fb24316f3b";
    hash = "sha256-bwybMxIAbOzPr43QGshjbnRK5GdziGiYDsTutZdSj4s=";
  };

  buildInputs = [
    ladspa-sdk
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local "$out"
  '';

  meta = {
    homepage = "https://tomscii.sig7.se/tap-plugins/";
    description = "Tom's Audio Processing plugins";
    longDescription = ''
      A number of LADSPA plugins including: TAP AutoPanner, TAP Chorus/Flanger,
      TAP DeEsser, TAP Dynamics (Mono & Stereo), TAP Equalizer and TAP
      Equalizer/BW, TAP Fractal Doubler, TAP Pink/Fractal Noise, TAP Pitch
      Shifter, TAP Reflector, TAP Reverberator, TAP Rotary Speaker, TAP Scaling
      Limiter, TAP Sigmoid Booster, TAP Stereo Echo, TAP Tremolo, TAP
      TubeWarmth, TAP Vibrato.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
