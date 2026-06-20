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
  version = "0.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "moyo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PnDE47R+OyJ5byBzjssHStTPtCZP9NUgIIO6065dLhI=";
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
    hash = "sha256-5/l3VL3CYTdTCrDXy8tg2hVXk9ZcUBoKtXPPIQcuAuc=";
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
