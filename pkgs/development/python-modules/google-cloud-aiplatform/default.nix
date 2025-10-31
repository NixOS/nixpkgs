{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # dependencies
  google-api-core,
  google-auth,
  google-cloud-core,
  google-cloud-storage_2_19,
  google-cloud-bigquery,
  google-cloud-resource-manager,
  grpcio,
  packaging,
  proto-plus,
  protobuf,
  shapely,
}:

buildPythonPackage rec {
  pname = "google-cloud-aiplatform";
  version = "1.98.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-aiplatform";
    tag = "v${version}";
    hash = "sha256-qy83UljhUCKfplE3mgy83Se3JT9Mn/C8v1uhpdSB9+8=";
  };

  dependencies = [
    google-api-core
    google-auth
    google-cloud-core
    google-cloud-storage_2_19
    google-cloud-bigquery
    google-cloud-resource-manager
    grpcio
    packaging
    proto-plus
    protobuf
    shapely
  ];

  pythonImportsCheck = [ "google.cloud.aiplatform" ];

  meta = {
    description = "A Python SDK for Vertex AI, a fully managed, end-to-end platform for data science and machine learning.";
    homepage = "https://github.com/googleapis/python-aiplatform";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ RajwolChapagain ];
  };
}
