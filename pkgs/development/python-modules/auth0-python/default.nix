{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12870b4806095b707c4eed7bf8cdfeb3722d990366bc6a9772d1520e90efa73b";
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
