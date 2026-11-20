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

buildPythonPackage rec {
  pname = "dettato";
  version = "2.0.0-unstable-2026-11-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kobimusic";
    repo = pname;
    rev = "9b724251794f2bbd5eaa43e54734e5a251829130";
    hash = "sha256-r11uQaEN9VJmqCZX2+cK9KsWAjHdS/UxHevceKWn7CE=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    torch
    numpy
    scipy
    soundfile
    soxr
    pretty-midi
    huggingface-hub
    safetensors
  ];

  meta = with lib; {
    description = "Multi-instrument audio-to-MIDI transcriber";
    homepage = "https://github.com/kobimusic/dettato";
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
