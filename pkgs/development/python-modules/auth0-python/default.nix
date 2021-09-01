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
  version = "3.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b21bf91859ea56ac3b665efe5e73340c65dfd30de01081ff334a18a35a188a6";
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
  ];

  pythonImportsCheck = [ "auth0" ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
