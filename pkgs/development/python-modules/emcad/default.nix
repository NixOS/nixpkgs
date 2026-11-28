{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  loguru,
  matplotlib,
  msgpack,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "emcad";
  version = "0.2.0-unstable-2026-10-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "emcad";
    rev = "350b7a53be16dae9b5fdb6fde7c6e88354a199cc";
    hash = "sha256-w+SLfd4Ckt77cMQFHjj6dirKvPxuod19S0pAawlDmDA=";
  };

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-FclwPqDXzv1y1W8FJndijn2nDx6jxC9oOBMcvXG+v98=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    loguru
    matplotlib
    msgpack
    numpy
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "emcad"
  ];

  meta = {
    description = "2D polygon/CAD geometry kernel and ODB++ PCB format parser";
    homepage = "https://github.com/FennisRobert/emcad";
    license = lib.licenses.mit;
    # dependency of emerge
    teams = with lib.teams; [ ngi ];
  };
})
