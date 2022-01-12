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
  version = "3.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed33557f252cf8b022b788ebd2b851c681979f200171498acde2b92d760db026";
  };

  propagatedBuildInputs = [
    requests
    pyjwt
  ];

  checkInputs = [
    mock
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
