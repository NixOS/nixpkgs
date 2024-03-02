{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-workflows";
  version = "1.14.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L1gL3r+HzywvsbfWk28Rthwm8lqz0S9ekTcWUh8FcLM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.workflows"
    "google.cloud.workflows_v1"
    "google.cloud.workflows_v1beta"
  ];

  meta = with lib; {
    description = "Python Client for Cloud Workflows";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-workflows";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-workflows-v${version}/packages/google-cloud-workflows/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
