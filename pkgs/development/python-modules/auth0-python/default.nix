{ lib
, buildPythonPackage
, fetchPypi
, requests
, mock
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
  ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
