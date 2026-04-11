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

buildPythonPackage (finalAttrs: {
  pname = "fastexcel";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ToucanToco";
    repo = "fastexcel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BMFZOduKN6D3y9aRkt9VAG2T9oNFBUcnmux1qTKgY5c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-aTYwXJN2hncZsEAGSlQzK5cX4uWpNoS0wpsXL0I6pZo=";
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
    changelog = "https://github.com/ToucanToco/fastexcel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
