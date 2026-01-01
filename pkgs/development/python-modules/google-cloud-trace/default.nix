{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-trace";
<<<<<<< HEAD
  version = "1.17.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_trace";
    inherit version;
    hash = "sha256-aHA7/JNxgIPwYdkTCjhS4xgewba3lrdoVpl8KPUblZU=";
=======
  version = "1.16.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_trace";
    inherit version;
    hash = "sha256-ib7yI6USRllR60kzW+bWC+4DltV2YC2/VjaEOdMDyrQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Tests require credentials
    "test_batch_write_spans"
    "test_list_traces"
  ];

  pythonImportsCheck = [
    "google.cloud.trace"
    "google.cloud.trace_v1"
    "google.cloud.trace_v2"
  ];

<<<<<<< HEAD
  meta = {
    description = "Cloud Trace API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-trace";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-trace-v${version}/packages/google-cloud-trace/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Cloud Trace API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-trace";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-trace-v${version}/packages/google-cloud-trace/CHANGELOG.md";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
