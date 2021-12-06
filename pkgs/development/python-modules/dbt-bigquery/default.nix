{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, protobuf
, google-cloud-core
, google-cloud-bigquery
, google-api-core
, googleapis-common-protos
, dbt-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    dbt-core
    protobuf
    google-cloud-core
    google-cloud-bigquery
    google-api-core
    googleapis-common-protos
  ];

  checkInputs = [
    pytestCheckHook
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0X6I1LNTSlgI/+/RlUxp3zzpPkrJuHIZaR6+s4SzSdM=";
  };

  meta = with lib; {
    description = "BigQuery adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
