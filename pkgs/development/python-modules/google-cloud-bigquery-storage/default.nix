{
  lib,
  buildPythonPackage,
  fastavro,
  fetchPypi,
  google-api-core,
  google-auth,
  google-cloud-bigquery,
  pandas,
  protobuf,
  pyarrow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-storage";
  version = "2.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GV/9KxgOnqoivqs+QKC2Hs0UbssyZnz0Immo1xEbTUg=";
  };

  propagatedBuildInputs = [
    google-api-core
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    fastavro = [ fastavro ];
    pandas = [ pandas ];
    pyarrow = [ pyarrow ];
  };

  nativeCheckInputs = [
    google-auth
    google-cloud-bigquery
    pytestCheckHook
  ];

  # Dependency loop with google-cloud-bigquery
  doCheck = false;

  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.bigquery_storage"
    "google.cloud.bigquery_storage_v1"
    "google.cloud.bigquery_storage_v1beta2"
  ];

  meta = with lib; {
    description = "BigQuery Storage API API client library";
    mainProgram = "fixup_bigquery_storage_v1_keywords.py";
    homepage = "https://github.com/googleapis/python-bigquery-storage";
    changelog = "https://github.com/googleapis/python-bigquery-storage/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
