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
  version = "3.16.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Slpwml1GDdxAZ4P6Vn2brrupRofiOHvmQF26l0gtTJM=";
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
