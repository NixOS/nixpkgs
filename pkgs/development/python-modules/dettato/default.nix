{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  torch,
  numpy,
  scipy,
  soundfile,
  soxr,
  pretty-midi,
  huggingface-hub,
  safetensors,
}:

buildPythonPackage (finalAttrs: {
  pname = "dettato";
  version = "2.0.0-unstable-2026-11-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kobimusic";
    repo = "dettato";
    rev = "9b724251794f2bbd5eaa43e54734e5a251829130";
    hash = "sha256-r11uQaEN9VJmqCZX2+cK9KsWAjHdS/UxHevceKWn7CE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
    numpy
    scipy
    soundfile
    soxr
    pretty-midi
    huggingface-hub
    safetensors
  ];

  meta = {
    description = "Multi-instrument audio-to-MIDI transcriber";
    homepage = "https://github.com/kobimusic/dettato";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ astro ];
  };
})
