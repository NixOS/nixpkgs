{ lib
, buildPythonPackage
, fetchPypi

# build-system
, cython_3
, meson-python
, ninja
, setuptools

# dependencies
, numpy
, scipy
, nibabel
, sympy
, transforms3d

# optional-dependencies
, matplotlib

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "nipy";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BTn2nV4VMeT8bxTOJTHjRU8I2bxFZCzIZCZVn/QcUrk=";
  };

  postPatch = ''
    patchShebangs nipy/_build_utils/cythoner.py
  '';

  build-system = [
    cython_3
    meson-python
    setuptools
    ninja
    numpy
  ];

  dependencies = [
    nibabel
    numpy
    scipy
    sympy
    transforms3d
  ];

  optional-dependencies.optional = [
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.optional;

  doCheck = false; # partial imports … circular dependencies. needs more time to figure out.

  pythonImportsCheck = [
    "nipy"
    "nipy.testing"
    "nipy.algorithms"
  ];

  meta = with lib; {
    homepage = "https://nipy.org/nipy";
    description = "Software for structural and functional neuroimaging analysis";
    downloadPage = "https://github.com/nipy/nipy";
    license = licenses.bsd3;
  };

}
