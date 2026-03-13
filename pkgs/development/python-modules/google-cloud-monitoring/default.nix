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
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-monitoring";
  version = "2.29.1";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_monitoring";
    inherit (finalAttrs) version;
    hash = "sha256-hsrFXN0mCFYYGdGVRPs8Epu7fc7MRF2N5CbjTNb6jkk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    pandas = [ pandas ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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

  meta = {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-monitoring";
    changelog = "https://github.com/googleapis/google-cloud-python/tree/google-cloud-monitoring-v${finalAttrs.version}/packages/google-cloud-monitoring";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
