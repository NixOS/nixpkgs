{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, libcst
, mock
, protobuf
, proto-plus
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rp/clC5lN3+fc3bz3Qb+oqHyVMS+jLX9gxxB0zOCxfM=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    protobuf
    proto-plus
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.websecurityscanner_v1alpha"
    "google.cloud.websecurityscanner_v1beta"
  ];

  meta = with lib; {
    description = "Google Cloud Web Security Scanner API client library";
    homepage = "https://github.com/googleapis/python-websecurityscanner";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
