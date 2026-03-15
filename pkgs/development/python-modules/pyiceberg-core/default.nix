{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  datafusion,
  fastavro,
  pyarrow,
  pydantic-core,
  pyiceberg,
  pytestCheckHook,

  # passthru
  pyiceberg-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyiceberg-core";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "iceberg-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q5eghj469gT9FkbBMgrHcV1bMCTAgAzz1ir7zEx1DAk=";
  };

  sourceRoot = "${finalAttrs.src.name}/bindings/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-R/SgYjlxRvlkgn/n8O87Nko0BxenioACqonGa1c9h9E=";
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

  disabledTests = [
    # AttributeError: 'function' object has no attribute 'cache_clear'
    "test_read_manifest_entry"
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
