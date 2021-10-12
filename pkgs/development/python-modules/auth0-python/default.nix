{ lib
, buildPythonPackage
, fetchPypi
, mock
, pyjwt
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jitJF+puXaLv3qyJOjLFetzxRpnlbi4BKS0TzDmCRe8=";
  };

  propagatedBuildInputs = [
    requests
    pyjwt
  ];

  checkInputs = [
    mock
    pyjwt
    pytestCheckHook
  ];

  disabledTests = [
    # tries to ping websites (e.g. google.com)
    "can_timeout"
    "test_options_are_created_by_default"
    "test_options_are_used_and_override"
  ];

  pythonImportsCheck = [ "auth0" ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
