{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-vpc-access";
  version = "1.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_vpc_access";
    inherit (finalAttrs) version;
    hash = "sha256-kO/iNVmRbMzoNErXVnarpkATXY+PwJiLVSoKpLui4Us=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.vpcaccess"
    "google.cloud.vpcaccess_v1"
  ];

  meta = {
    description = "Python Client for Virtual Private Cloud";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-vpc-access";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-vpc-access-v${finalAttrs.version}/packages/google-cloud-vpc-access/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
