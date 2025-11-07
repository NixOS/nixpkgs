{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  datafusion,
  pyarrow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyiceberg-core";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "iceberg-rust";
    tag = "v${version}";
    hash = "sha256-vRSZnMkZptGkLZBN1RRu0YGRQCOgJioBIghXnvU9UXc=";
  };

  sourceRoot = "${src.name}/bindings/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-QfNVqyZ/O3vZAf689Fg5qPY6jcN4G1zo2eS2AEcdIL4=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "pyiceberg_core" ];

  nativeCheckInputs = [
    pyarrow
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Circular dependency on pyiceberg
    "tests/test_datafusion_table_provider.py"
  ];

  meta = {
    description = "Iceberg-rust powered core for pyiceberg";
    homepage = "https://github.com/apache/iceberg-rust/tree/main/bindings/python";
    changelog = "https://github.com/apache/iceberg-rust/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
