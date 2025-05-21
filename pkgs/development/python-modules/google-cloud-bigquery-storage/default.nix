{
  lib,
  buildPythonPackage,
  fastavro,
  fetchFromGitHub,
  google-api-core,
  google-auth,
  google-cloud-bigquery,
  pandas,
  protobuf,
  pyarrow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-storage";
  version = "2.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-bigquery-storage";
    tag = "v${version}";
    hash = "sha256-l4q8L8c4LCGacvaY1znNWEHYS1LYg6CcY/9NJoFTOCU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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

  meta = {
    description = "BigQuery Storage API API client library";
    homepage = "https://github.com/googleapis/python-bigquery-storage";
    changelog = "https://github.com/googleapis/python-bigquery-storage/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
    mainProgram = "fixup_bigquery_storage_v1_keywords.py";
  };
}
