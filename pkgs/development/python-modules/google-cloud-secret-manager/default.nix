{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vlMh7Ww7ZPHWVUJMDqRO58bmn4nfTi3Gj/sBReHOvtQ=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    libcst
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.secretmanager"
    "google.cloud.secretmanager_v1"
    "google.cloud.secretmanager_v1beta1"
  ];

  meta = with lib; {
    description = "Secret Manager API API client library";
    homepage = "https://github.com/googleapis/python-secret-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli SuperSandro2000 ];
  };
}
