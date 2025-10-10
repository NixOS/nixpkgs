{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  pyinstaller,

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
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aviramha";
    repo = "ormsgpack";
    tag = version;
    hash = "sha256-7VESiHAkDynf31xrQQh0Vv5vSfMOjnVXRFackUQdB68=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-um6PzwL0M5lz4gDkTO/lvWJ0wwuCneNKRW8qysKMmM0=";
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

  nativeBuildInputs = [
    pyinstaller
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
