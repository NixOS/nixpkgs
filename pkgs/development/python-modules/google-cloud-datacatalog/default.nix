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
  version = "3.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1VhEg22JMfUDeMT5/A1uX7jwqND4i0zVScFpMJKyCro=";
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
