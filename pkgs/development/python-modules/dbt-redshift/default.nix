{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, boto3
, dbt-core
, dbt-postgres
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "1.0.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    boto3
    dbt-core
    dbt-postgres
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZBkhKxxUA1jyubMkCPzmvqyTh8QPgQ2Y33gEOV6Sc78=";
  };

  meta = with lib; {
    description = "Amazon Redshift adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
