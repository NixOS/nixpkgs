{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e968d01364c8c94fbe85154ab77ebe9e51a3f8282405bb33748071452063004";
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
