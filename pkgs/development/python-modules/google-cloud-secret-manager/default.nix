{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc_google_iam_v1
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e99eb9f77373b97bfc1becb7d23fae5574a33fd9e44b44a3e700abcbfbc9f94d";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc_google_iam_v1
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
