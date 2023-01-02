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
}:

buildPythonPackage rec {
  pname = "google-cloud-compute";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pnhXkYSXph7aIZJoI3tXTNIUkH44S22QDIGXUl9ceFU=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.compute"
    "google.cloud.compute_v1"
  ];

  # disable tests that require credentials
  disabledTestPaths = [
    "tests/system/test_addresses.py"
    "tests/system/test_instance_group.py"
    "tests/system/test_pagination.py"
    "tests/system/test_smoke.py"
  ];

  meta = with lib; {
    description = "API Client library for Google Cloud Compute";
    homepage = "https://github.com/googleapis/python-compute";
    changelog = "https://github.com/googleapis/python-compute/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
