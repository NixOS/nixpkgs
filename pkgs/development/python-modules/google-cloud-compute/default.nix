{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, google-api-core
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-compute";
  version = "1.15.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+mda6vBMYnpELNMDIZbW82rWhEO6MnyXZ6a/vECkKyE=";
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
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.compute"
    "google.cloud.compute_v1"
  ];

  disabledTestPaths = [
    # Disable tests that require credentials
    "tests/system/test_addresses.py"
    "tests/system/test_instance_group.py"
    "tests/system/test_pagination.py"
    "tests/system/test_smoke.py"
  ];

  meta = with lib; {
    description = "API Client library for Google Cloud Compute";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-compute";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-compute-v${version}/packages/google-cloud-compute/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
