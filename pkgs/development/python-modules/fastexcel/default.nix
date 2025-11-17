{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  cargo,
  rustc,

  # optional-dependencies
  pandas,
  polars,
  pyarrow,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastexcel";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ToucanToco";
    repo = "fastexcel";
    tag = "v${version}";
    hash = "sha256-6pEE3l3qJ3Nir4oDFXdsGiX/2d1w3bqH0nrIOjBt9PM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ULRK7GjMEs0mN/H491XANDT7eipOdPfJyGFtPBM3SC8=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  maturinBuildFlags = [
    "--features __maturin"
  ];

  optional-dependencies = {
    pyarrow = [
      pyarrow
    ];
    pandas = [
      pandas
      pyarrow
    ];
    polars = [
      polars
    ];
  };

  pythonImportsCheck = [
    "fastexcel"
    "fastexcel._fastexcel"
  ];

  preCheck = ''
    rm -rf python/fastexcel
  '';

  nativeCheckInputs = [
    pandas
    polars
    pyarrow
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
