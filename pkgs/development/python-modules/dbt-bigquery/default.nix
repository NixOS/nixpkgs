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
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "1.0.0";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    dbt-core
    protobuf
    google-cloud-core
    google-cloud-bigquery
    google-api-core
    googleapis-common-protos
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4iRC8A/OwVXcv+i+NRoRw1kT+27dEb1eUvr8Mhir0S4=";
  };

  meta = with lib; {
    description = "BigQuery adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
