{ lib
, buildPythonPackage
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "ci-maintenance.patch";
      url = "https://github.com/cms-nanoAOD/correctionlib/commit/924031637b040f6e8e4930c46a9f7560c59db23d.patch";
      hash = "sha256-jq3ojMsO2Ex9om8tVpEY9uwwelXPzgQ+KCPN0bgda8w=";
      includes = [ "pyproject.toml" ];
    })
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/cms-nanoAOD/correctionlib/commit/c4fd64ca0e5ce806890e8f0ae8e792dcc4537d38.patch";
      hash = "sha256-8ID2jEnmfYmPxWMtRviBc3t1W4p3Y+lAzijFtYBEtyk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    numpy
    scikit-build
    setuptools
    setuptools-scm
    wheel
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

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
