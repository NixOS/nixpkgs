{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac7808d00676c5e7ffa9eaa228807ca1f8db7a0f4dc115337c80fb6d7eb2b50a";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # jwt package is not available in nixpkgs
    "--ignore=auth0/v3/test/authentication/test_token_verifier.py"
  ];

  # tries to ping websites (e.g. google.com)
  disabledTests = [
    "can_timeout"
  ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
