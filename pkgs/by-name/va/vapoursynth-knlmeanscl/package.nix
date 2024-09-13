{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  vapoursynth,
  opencl-headers,
  ocl-icd,
}:

stdenv.mkDerivation {
  pname = "vapoursynth-knlmeanscl";
  version = "unstable-2023-06-05";

  src = fetchFromGitHub {
    owner = "Khanattila";
    repo = "KNLMeansCL";
    rev = "ca424fa91d1e16ec011f7db9c3ba0d1e76ed7850";
    hash = "sha256-co8Jaup3bvvJaKw830CqCkAKHRsT5rx/xAYMbGhrMRk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    vapoursynth
    ocl-icd
    opencl-headers
  ];

  postPatch = ''
    rm -rf KNLMeansCL/{avi,vapour}synth
    sed -E -i '/NLMAvisynth\.(h|cpp)/d' meson.build
  '';

  meta = {
    description = "Plugin for VapourSynth: knlmeanscl";
    homepage = "https://github.com/Khanattila/KNLMeansCL";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
}
