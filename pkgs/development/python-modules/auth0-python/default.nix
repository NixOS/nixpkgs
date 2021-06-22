{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
, pyjwt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.16.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a5a709a5d460ddc406783fa567d9baebba94687e2387be6405dba97482d4c93";
  };

  propagatedBuildInputs = [
    requests
    pyjwt
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
