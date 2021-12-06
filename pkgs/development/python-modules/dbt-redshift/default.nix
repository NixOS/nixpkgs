{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, boto3
, dbt-core
, dbt-postgres
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    boto3
    dbt-core
    dbt-postgres
  ];

  checkInputs = [
    pytestCheckHook
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ecKfDAMnQf3+/7I/k4jr9lnJuCqnCyKIhteedjvb7PI=";
  };

  meta = with lib; {
    description = "Amazon Redshift adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
