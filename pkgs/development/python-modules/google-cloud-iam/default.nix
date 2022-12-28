{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-iam";
  version = "2.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8q/Am7x5LFN9Uaw37QdUdwL19J1FgxRKjRL0Vrc+1TI=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
  ] ++ google-api-core.optional-dependencies.grpc;

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.iam_credentials"
    "google.cloud.iam_credentials_v1"
  ];

  meta = with lib; {
    description = "IAM Service Account Credentials API client library";
    homepage = "https://github.com/googleapis/python-iam";
    changelog = "https://github.com/googleapis/python-iam/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
