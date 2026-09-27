{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "pyinputevent";
  version = "0.1-unstable-2015-10-18";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ntzrmtthihu777";
    repo = "pyinputevent";
    rev = "d2075fa5db5d8a402735fe788bb33cf9fe272a5b";
    hash = "sha256-K2qTGejOeG4Ulg0MusMnQtEG95ppydMBYDI5dDvQcWY=";
  };

  build-system = [ setuptools ];

  meta = {
    homepage = "https://github.com/ntzrmtthihu777/pyinputevent";
    description = "Python interface to the Input Subsystem's input_event and uinput";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
