{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-org-policy";
  version = "1.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_org_policy";
    inherit (finalAttrs) version;
    hash = "sha256-xyFHEn2I2YCa+HOLKr40gG6sUpw83FeqkVzAihuEKhM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud.orgpolicy" ];

  meta = {
    description = "Protobufs for Google Cloud Organization Policy";
    homepage = "https://github.com/googleapis/python-org-policy";
    changelog = "https://github.com/googleapis/python-org-policy/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
  };
})
