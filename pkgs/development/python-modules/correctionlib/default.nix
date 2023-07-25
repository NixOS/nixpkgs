{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, scikit-build
, setuptools
, setuptools-scm
, pybind11
, pydantic
, pytestCheckHook
, rich
, scipy
, zlib
}:

buildPythonPackage rec {
  pname = "correctionlib";
  version = "2.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h3eggtPLSF/8ShQ5xzowZW1KSlcI/YBsPu3lsSyzHkw=";
  };

  nativeBuildInputs = [
    cmake
    numpy
    scikit-build
    setuptools
    setuptools-scm
    pybind11
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    pydantic
    rich
  ];

  dontUseCmakeConfigure = true;

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [
    "correctionlib"
  ];

  meta = with lib; {
    description = "Provides a well-structured JSON data format for a wide variety of ad-hoc correction factors encountered in a typical HEP analysis";
    homepage = "https://cms-nanoaod.github.io/correctionlib/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
