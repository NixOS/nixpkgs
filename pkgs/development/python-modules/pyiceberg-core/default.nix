{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  datafusion,
  fastavro,
  pyarrow,
  pyiceberg,
  pytestCheckHook,

  # passthru
  pyiceberg-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyiceberg-core";
  version = "0.10.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "iceberg-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5l9pmXbQsiFCtDVop4Dq+FnAfiUBj4qFUMz7njx7/b0=";
  };

  sourceRoot = "${finalAttrs.src.name}/bindings/python";
  cargoRoot = "../..";

  # The workspace root is outside of `sourceRoot`, hence not writable
  env.CARGO_TARGET_DIR = "./target";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-0ZdjkQfOotd/Clxc/g14kYgAh4bUcKaa1+YVIgGydoI=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "pyiceberg_core" ];

  nativeCheckInputs = [
    datafusion
    fastavro
    pyiceberg
    pyarrow
    pytestCheckHook
  ]
  ++ pyiceberg.optional-dependencies.pyarrow
  ++ pyiceberg.optional-dependencies.sql-sqlite;

  disabledTestPaths = [
    # Segfaults: the bundled `datafusion-ffi` 53.x is ABI-incompatible with the
    # packaged `datafusion` 54.x
    # https://github.com/apache/datafusion/issues/17374
    "tests/test_datafusion_table_provider.py"
  ];

  disabledTests = [
    # Same `datafusion-ffi` ABI mismatch as above
    "test_cdc_write_and_read_via_datafusion"
  ];

  # Circular dependency on pyiceberg
  doCheck = false;

  passthru.tests.pytest = pyiceberg-core.overridePythonAttrs {
    doCheck = true;
  };

  meta = {
    description = "Iceberg-rust powered core for pyiceberg";
    homepage = "https://github.com/apache/iceberg-rust/tree/main/bindings/python";
    changelog = "https://github.com/apache/iceberg-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
