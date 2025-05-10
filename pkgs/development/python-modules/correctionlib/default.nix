{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  scikit-build-core,
  setuptools-scm,

  # nativeBuildInputs
  cmake,
  ninja,

  # buildInputs
  zlib,

  # dependencies
  numpy,
  packaging,
  pydantic,
  rich,

  # tests
  addBinToPathHook,
  awkward,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "correctionlib";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cms-nanoAOD";
    repo = "correctionlib";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-aLTeyDOo80p8xzl/IPnpT3BOjS2qOYn/Z7pidcLoEY8=";
  };

  build-system = [
    pybind11
    scikit-build-core
    setuptools-scm
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [ zlib ];

  dependencies = [
    numpy
    packaging
    pydantic
    rich
  ];

  nativeCheckInputs = [
    # One test requires running the produced `correctionlib` binary
    addBinToPathHook

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
