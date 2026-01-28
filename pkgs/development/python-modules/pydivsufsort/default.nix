{
  buildPythonPackage,
  cython,
  fetchPypi,
  lib,
  numpy,
  setuptools,
  cmake,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydivsufsort";
  version = "0.0.20";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-aFpXkfrl4gDOi3pOXVFbYVP/3nF1MxvQ34GkIRCK1N8=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail /bin/bash bash
    patchShebangs build.sh
  '';

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  build-system = [ setuptools ];
  dependencies = [
    cython
    numpy
  ];

  meta = {
    description = "Python package for string algorithms";
    homepage = "https://github.com/louisabraham/pydivsufsort";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
  };
})
