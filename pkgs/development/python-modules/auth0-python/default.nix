{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ad17af5f0099f687cc6707ef2049364b5058c18db14e2a0a85a0eedf83ea627";
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
