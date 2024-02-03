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
, rich
, awkward
, pytestCheckHook
, scipy
, zlib
}:

buildPythonPackage rec {
  pname = "correctionlib";
  version = "2.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4WXY7XfZVYaJD63y7fPB6tCsc+wGAsgnFlgtFbX5IK0=";
  };

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
    awkward
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
