{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_api_core, libcst, mock, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-iam";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zxsx5avs8njiyw32zvsx2yblmmiwxy771x334hbgmy0aqms4lak";
  };

  propagatedBuildInputs = [ google_api_core libcst proto-plus ];
  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  meta = with lib; {
    description = "Google Cloud IAM API client library";
    homepage = "https://github.com/googleapis/python-iam";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
