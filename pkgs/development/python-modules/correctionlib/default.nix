{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  scikit-build,
  setuptools,
  setuptools-scm,
  pybind11,

  zlib,

  # dependencies
  numpy,
  packaging,
  pydantic,
  rich,

  # checks
  awkward,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "correctionlib";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cms-nanoAOD";
    repo = "correctionlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-RI0wL+/6aNCV9PZMY9ZLNFLVYPm9kAyxcvLzLLM/T3Y=";
    fetchSubmodules = true;
  };

  build-system = [
    cmake
    scikit-build
    setuptools
    setuptools-scm
    pybind11
  ];

  buildInputs = [ zlib ];

  dependencies = [
    numpy
    packaging
    pydantic
    rich
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    awkward
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "correctionlib" ];

  meta = {
    description = "Provides a well-structured JSON data format for a wide variety of ad-hoc correction factors encountered in a typical HEP analysis";
    mainProgram = "correction";
    homepage = "https://cms-nanoaod.github.io/correctionlib/";
    changelog = "https://github.com/cms-nanoAOD/correctionlib/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
