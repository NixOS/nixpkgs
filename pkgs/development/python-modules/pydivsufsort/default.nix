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

  patches = [
    # build.sh picks "the two largest files" out of the cmake output by
    # allocated disk blocks, which depend on the build filesystem, so it can
    # select a soname symlink instead of libdivsufsort. Compare apparent sizes
    # instead.
    ./deterministic-library-selection.patch
  ];

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

  pythonImportsCheck = [ "pydivsufsort" ];

  meta = {
    description = "Bindings to `libdivsufsort`";
    homepage = "https://github.com/louisabraham/pydivsufsort";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
  };
})
