{
  buildPythonPackage,
  cmake,
  cython,
  fetchPypi,
  lib,
  numpy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydivsufsort";
  version = "0.0.20";

  pyproject = true;

  # The repo hosted on github does not have tags, so we use fetchPypi, though
  # we should replace with fetchFromGitHub when we have
  # https://github.com/louisabraham/pydivsufsort/issues/52
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
    description = "Bindings to `libdivsufsort`";
    homepage = "https://github.com/louisabraham/pydivsufsort";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
  };
})
