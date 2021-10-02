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
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6508a260ea273de0ff17d0bf66a3f93009a9b02ace7736486f70a91789c3e34a";
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
