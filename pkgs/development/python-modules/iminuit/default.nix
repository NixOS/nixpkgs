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
  version = "2.24.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JatjHDyOAksbzHyW9mM4yqxUpKIyTVXx47pWF4FuRP0=";
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
