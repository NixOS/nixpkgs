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
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-storage";
  version = "2.32.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_bigquery_storage";
    inherit version;
    hash = "sha256-6UT19DhfC+J+BJ5z5NzPVIt3NIMBZjp3O10Dq9vUniA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
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
    homepage = "https://github.com/googleapis/python-bigquery-storage";
    changelog = "https://github.com/googleapis/python-bigquery-storage/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "fixup_bigquery_storage_v1_keywords.py";
  };
}
