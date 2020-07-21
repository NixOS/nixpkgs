{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e02525fd60d4b1e7e08bdc539b536db635da28ee25cc882412be4296802d0281";
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
