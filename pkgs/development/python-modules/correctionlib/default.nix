{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, scikit-build
, setuptools
, setuptools-scm
, wheel
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

  # 1. We use native cmake instead of the cmake module from PyPI.
  # 2. We don't need make
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"cmake>=3.11.0",' "" \
      --replace '"make"' ""
  '';

  nativeBuildInputs = [
    cmake
    numpy
    scikit-build
    setuptools
    setuptools-scm
    pybind11
    wheel
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
