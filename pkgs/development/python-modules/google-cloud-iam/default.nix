{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, google-api-core
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-iam";
  version = "2.3.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "166pcra1x8lisgf7cla4vq97qpc1hrpwnvlj1sza1igny2m59w5i";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [
    "google.cloud.iam_credentials"
    "google.cloud.iam_credentials_v1"
  ];

  meta = with lib; {
    description = "IAM Service Account Credentials API client library";
    homepage = "https://github.com/googleapis/python-iam";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
