{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  cargo,
  rustc,

  # dependencies
  pyarrow,

  # optional-dependencies
  pandas,
  polars,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastexcel";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ToucanToco";
    repo = "fastexcel";
    tag = "v${version}";
    hash = "sha256-o2+LNpl431/l4YL5/jnviDwZ5D+WjcFRoNV5hLuvRhM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-VZoloGsYLAHqeqRkeZi0PZUpN/i+bWlebzL4wDZNHeo=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    pyarrow
  ];

  optional-dependencies = {
    pandas = [
      pandas
    ];
    polars = [
      polars
    ];
  };

  pythonImportsCheck = [
    "fastexcel"
  ];

  nativeCheckInputs = [
    pandas
    polars
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Fast excel file reader for Python, written in Rust";
    homepage = "https://github.com/ToucanToco/fastexcel/";
    changelog = "https://github.com/ToucanToco/fastexcel/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
