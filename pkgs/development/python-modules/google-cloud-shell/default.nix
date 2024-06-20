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
  pname = "google-cloud-shell";
  version = "1.9.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-33TZcRsOWP8PBAXFHy9DQn20bVECwD2wv7hcaYl0E8Y=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    "google.cloud.shell"
    "google.cloud.shell_v1"
  ];

  meta = with lib; {
    description = "Python Client for Cloud Shell";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-shell";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-shell-v${version}/packages/google-cloud-shell/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
