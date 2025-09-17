{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # dependencies
  typing-extensions,

  # tests
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "moyopy";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "moyo";
    tag = "v${version}";
    hash = "sha256-LMmPWE9XMj/DpsE2B9gZTqol/pG8a+RRYsLltBI/Kgc=";
  };

  sourceRoot = "${src.name}/moyopy";
  cargoRoot = "..";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  env = {
    CARGO_TARGET_DIR = "./target";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-A0rKr2Mn9cRiLO8UwnjhdDFSr4JpXQ2RNnASkpw/Rfg=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "moyopy" ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Circular dependency with pymatgen
    "python/tests/test_interface.py"
  ];

  meta = {
    description = "Python interface of moyo, a fast and robust crystal symmetry finder";
    homepage = "https://spglib.github.io/moyo/python/";
    changelog = "https://github.com/spglib/moyo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
