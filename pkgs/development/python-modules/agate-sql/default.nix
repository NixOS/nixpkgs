{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
  agate,
  sqlalchemy,
  crate,
  pytestCheckHook,
  geojson,
}:

buildPythonPackage rec {
  pname = "agate-sql";
  version = "0.7.2";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mxswKEpXP9QWdZQ3Jz3MXIECK98vrLJLSqAppir9U7A=";
  };

  propagatedBuildInputs = [
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
}
