{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, boto3
, dbt-postgres
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    boto3
    dbt-postgres
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0";
  };

  meta = with lib; {
    description = "Amazon Redshift adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
