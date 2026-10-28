{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,

  # dependencies
  msgpack,

  # testing
  pydantic,
  pytestCheckHook,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "ormsgpack";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aviramha";
    repo = "ormsgpack";
    tag = version;
    hash = "sha256-O4497RObrvDViQVKbpsG2XCG4L570pDGpZEfIGDxEmM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-6Xmu5GgcC6DuxBk4d/M3p8lboEhG5+8HwW2LnivpHHE=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  # requires nightly features (feature(portable_simd))
  env.RUSTC_BOOTSTRAP = true;

  dependencies = [
    msgpack
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pydantic
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [
    "ormsgpack"
  ];

  meta = {
    description = "Fast msgpack serialization library for Python derived from orjson";
    homepage = "https://github.com/aviramha/ormsgpack";
    changelog = "https://github.com/aviramha/ormsgpack/releases/tag/${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
