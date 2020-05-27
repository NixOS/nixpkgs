{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2fdc3ff230638a2776d2b3761e787ca93dc33a26f841504fc260f947256f453";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    mock
  ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
