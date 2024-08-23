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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-vpc-access";
  version = "1.10.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "google_cloud_vpc_access";
    inherit version;
    hash = "sha256-ee0O0MDo3VEUuansbm0Io35g/8aRA2ShoZh+IfwQAww=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.vpcaccess"
    "google.cloud.vpcaccess_v1"
  ];

  meta = with lib; {
    description = "Python Client for Virtual Private Cloud";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-vpc-access";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-vpc-access-v${version}/packages/google-cloud-vpc-access/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
