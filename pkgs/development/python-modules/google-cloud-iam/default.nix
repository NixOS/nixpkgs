{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google-api-core, libcst, mock, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-iam";
  version = "2.5.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b26294d02b14b40586eceb099a0e3a74265ae10a3f46fd49890cac55ad5f861f";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck =
    [ "google.cloud.iam_credentials" "google.cloud.iam_credentials_v1" ];

  meta = with lib; {
    description = "IAM Service Account Credentials API client library";
    homepage = "https://github.com/googleapis/python-iam";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
