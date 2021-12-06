{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, snowflake-connector-python
, keyring
, requests
, cryptography
, dbt-core
}:

buildPythonPackage rec {
  pname = "dbt-snowflake";
  version = "1.0.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    dbt-core
    snowflake-connector-python
    keyring
    requests
    cryptography
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "snowflake-connector-python[secure-local-storage]>=2.4.1,<2.8.0" "snowflake-connector-python>=2.4.1,<2.8.0"
  '';

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-omMnTWr0MO3+M89XtEx+ulinMBfsixyCyzCyXkK+mhw=";
  };

  meta = with lib; {
    description = "Snowflake adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
