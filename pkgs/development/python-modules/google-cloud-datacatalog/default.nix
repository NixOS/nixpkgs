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
  version = "3.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8TwAwl9/gq47lW+MXi5x2RlqaAs6dnQiuAZkb4oPD84=";
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
