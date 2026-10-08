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

buildPythonPackage (finalAttrs: {
  pname = "moyopy";
  version = "0.17.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "moyo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KmZx0bq7XRZViLhnFHi09UgBkysO31ZGx24egKUof3c=";
  };

  sourceRoot = "${finalAttrs.src.name}/moyopy";
  cargoRoot = "..";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  env = {
    CARGO_TARGET_DIR = "./target";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-x2UMZcTT8nSzHX+MI60+FJnpOLEBvdVWVqNo8p/BXZQ=";
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
    changelog = "https://github.com/spglib/moyo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
