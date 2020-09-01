{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbc54a231ca787ae0917223028269582abbd963cfa9d53ba822a601dd9cd2215";
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
