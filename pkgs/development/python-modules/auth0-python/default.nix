{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, callee
, fetchPypi
, mock
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.23.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sXEWg6zrwMs8pCSloJtLL3o7ZAXTTiMXEgI7sDaogr4=";
  };

  propagatedBuildInputs = [
    requests
    pyjwt
  ];

  checkInputs = [
    aiohttp
    aioresponses
    callee
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Tries to ping websites (e.g. google.com)
    "can_timeout"
    "test_options_are_created_by_default"
    "test_options_are_used_and_override"
  ];

  pythonImportsCheck = [
    "auth0"
  ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
