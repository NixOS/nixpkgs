{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, cmake
, scikit-build-core
, pybind11
, pathspec
, ninja
, pyproject-metadata

# dependencies
, numpy

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.25.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uCn/wdte1nHc0aSeBFk3duZXXPOmbMfOdHf8ZkI/hj4=";
  };

  nativeBuildInputs = [
    cmake
    scikit-build-core
    pybind11
    pathspec
    ninja
    pyproject-metadata
  ] ++ scikit-build-core.optional-dependencies.pyproject;

  propagatedBuildInputs = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/iminuit";
    description = "Python interface for the Minuit2 C++ library";
    license = with licenses; [ mit lgpl2Only ];
    maintainers = with maintainers; [ veprbl ];
  };
}
