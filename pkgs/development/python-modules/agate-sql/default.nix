{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  agate,
  setuptools,
  sqlalchemy,
  pytestCheckHook,
  geojson,
}:

buildPythonPackage (finalAttrs: {
  pname = "agate-sql";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate-sql";
    tag = finalAttrs.version;
    hash = "sha256-YPpvLMidW0RnNz1x6FK1QwhOIc9AhwnSm6vxUzbLLBM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    agate
    sqlalchemy
  ];

  nativeCheckInputs = [
    geojson
    pytestCheckHook
  ];

  pythonImportsCheck = [ "agatesql" ];

  disabledTests = [
    # requires crate (sqlalchemy-cratedb)
    "test_to_sql_create_statement_with_dialects"
  ];

  meta = {
    description = "Adds SQL read/write support to agate";
    homepage = "https://github.com/wireservice/agate-sql";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
})
