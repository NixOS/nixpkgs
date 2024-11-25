{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustPlatform,
  rustc,
  pyarrow,
  typing-extensions,
  pandas,
  polars,
}:

buildPythonPackage rec {
  pname = "fastexcel";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FiTixjhf4I1awhOSw6W9kRVvvuuvaYbm5/aErcDg7L4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-lspEpqyRyFD++BhG/ezDWAI6GncdzPTqdknuz9R5k2E=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    pyarrow
    typing-extensions
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

  # No tests present in the pypi archive
  doCheck = false;

  meta = {
    description = "A fast excel file reader for Python, written in Rust";
    homepage = "https://pypi.org/project/fastexcel/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    changelog = "https://github.com/ToucanToco/fastexcel/releases/tag/v${version}";
  };
}
