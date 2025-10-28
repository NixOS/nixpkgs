{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  juce,
  pkg-config,
  alsa-lib,
  fftwFloat,
  fontconfig,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vaporizer2";
  version = "3.5.0-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "VASTDynamics";
    repo = "Vaporizer2";
    rev = "1c56c4be304255f1c397dad725ea784f15a55ef5";
    hash = "sha256-/J0HqiXc84JEIsEyb1MlzAqpmJZEe8jP07fEcJSEZz8=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    juce
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fftwFloat
    fontconfig
    freetype
    libGL
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "USE_SYSTEM_JUCE" "ON")
  ];

  # LTO needs special setup on Linux
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  meta = {
    description = "Wavetable synthesizer";
    longDescription = ''
      Hybrid wavetable additive / subtractive VST / AU / AAX synthesizer / sampler workstation plugin
    '';
    homepage = "https://www.vast-dynamics.com/?q=Vaporizer2";
    downloadPage = "https://github.com/VASTDynamics/Vaporizer2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "VASTvaporizer2";
    platforms = lib.platforms.linux;
  };
})
