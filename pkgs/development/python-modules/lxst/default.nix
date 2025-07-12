{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxmf,
  numpy_1,
  pycodec2,
  rns,
  soundcard,
}:

buildPythonPackage rec {
  pname = "lxst";
  version = "0.3.0-unstable-2025-05-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxst";
    rev = "a0098cf74fb68d615c14951ccebae75d7797e374";
    hash = "sha256-Lb13M1Au+DOK7Uxcieo+57r6pnNtJdtESPUXVAoODO8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pycodec2
    numpy_1
    rns
    lxmf
    (soundcard.override { numpy = numpy_1; })
  ];

  meta = {
    description = "Simple and flexible real-time streaming format and delivery protocol for Reticulum";
    homepage = "https://github.com/markqvist/LXST";
    license = lib.licenses.cc-by-nc-nd-40;
    mainProgram = "rnphone";
  };
}
