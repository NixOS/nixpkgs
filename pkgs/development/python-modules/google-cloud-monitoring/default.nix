{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  mock,
  pandas,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.22.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2xexWvjUfaDPj7DjZfqvvNEfmqYngc4EjCmYiAiz3H0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    pandas = [ pandas ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ] ++ passthru.optional-dependencies.pandas;

  disabledTests = [
    # Test requires credentials
    "test_list_monitored_resource_descriptors"
    # Test requires PRROJECT_ID
    "test_list_alert_policies"
  ];

  pythonImportsCheck = [
    "google.cloud.monitoring"
    "google.cloud.monitoring_v3"
  ];

  meta = with lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-monitoring";
    changelog = "https://github.com/googleapis/google-cloud-python/tree/google-cloud-monitoring-v${version}/packages/google-cloud-monitoring";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
