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
  version = "0.20.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ToucanToco";
    repo = "fastexcel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YL8EkV6IuqAMxooOMbqCrTfDM4uhH9A+v7UFw1f/iek=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TK/5eES+RlSDFIbhVjzbPgdrDRRKZlCiuqtLRm8R/go=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
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
