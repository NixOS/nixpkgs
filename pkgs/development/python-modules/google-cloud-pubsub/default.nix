{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  grpc-google-iam-v1,
  grpcio-status,
  grpcio,
  libcst,
  opentelemetry-api,
  opentelemetry-sdk,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
  version = "2.31.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_pubsub";
    inherit version;
    hash = "sha256-9CFPaS2kNa/N+0HnfPqWIjjbluSkumRjeqpxBELZxTI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    grpcio
    grpcio-status
    libcst
    opentelemetry-api
    opentelemetry-sdk
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    libcst = [ libcst ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests in pubsub_v1 attempt to contact pubsub.googleapis.com
    "tests/unit/pubsub_v1"
  ];

  pythonImportsCheck = [ "google.cloud.pubsub" ];

  meta = with lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://github.com/googleapis/python-pubsub";
    changelog = "https://github.com/googleapis/python-pubsub/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "fixup_pubsub_v1_keywords.py";
  };
}
