{ lib
, buildPythonPackage
, fetchPypi
, libcst
, google-api-core
, grpc-google-iam-v1
, proto-plus
, pytest-asyncio
, pytestCheckHook
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pRFMFet7p5qvNOfti5bmehyTGNaXlxpXxZ/kOxdiiZU=";
  };

  propagatedBuildInputs = [
    libcst
    google-api-core
    grpc-google-iam-v1
    proto-plus
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [
    "google.cloud.datacatalog"
  ];

  meta = with lib; {
    description = "Google Cloud Data Catalog API API client library";
    homepage = "https://github.com/googleapis/python-datacatalog";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
