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

buildPythonPackage rec {
  pname = "google-cloud-vpc-access";
  version = "1.14.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_vpc_access";
    inherit version;
    hash = "sha256-N1CpDs/TgSCjJOnNwOJCaS7MWur95uoztvl+R5DjYC0=";
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

  meta = with lib; {
    description = "Python Client for Virtual Private Cloud";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-vpc-access";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-vpc-access-v${version}/packages/google-cloud-vpc-access/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
