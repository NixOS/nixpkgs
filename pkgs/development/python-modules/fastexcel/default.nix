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
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ToucanToco";
    repo = "fastexcel";
    tag = "v${version}";
    hash = "sha256-1BcArjhdbsYZ8VIz1FJYOLKSKQXOjLUXFonIXB+TfiY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-JGDNqRF264hNAjQ9bwJnBsQgAcqJjreEbgRZAA58JnY=";
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
