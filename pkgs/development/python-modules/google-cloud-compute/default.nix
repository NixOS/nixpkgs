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
  version = "1.5.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1crkhcf56U6DAx9xVG2e9hCxQ04OjQq2QgLs434cCv0=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ];

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
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
