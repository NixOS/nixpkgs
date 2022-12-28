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
  version = "2.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/FPuPDJC+AuRNCtKv7pFrpsOlopPFEV/KggDWulRU8A=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
  ];

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
