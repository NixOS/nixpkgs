{
  lib,
  stdenv,
  fetchgit,
  ladspa-sdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tap-plugins";
  version = "0-unstable-2023-07-14";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://git.hq.sig7.se/tap-plugins.git";
    rev = "85640223047d49a305e90ba1b92303eb066ba474";
    hash = "sha256-179ztvsmxJiKXJ1QCYHCqCv3R1XWLcvVlUXyqaZYb2o=";
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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
