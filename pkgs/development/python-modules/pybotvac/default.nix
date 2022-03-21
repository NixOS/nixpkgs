{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_oauthlib
, voluptuous
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54b4fe565c10000c54d5644d081e2de1f850daefbac39cea74cea649b47bfb12";
  };

  propagatedBuildInputs = [
    requests
    requests_oauthlib
    voluptuous
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pybotvac" ];

  meta = with lib; {
    description = "Python module for interacting with Neato Botvac Connected vacuum robots";
    homepage = "https://github.com/stianaske/pybotvac";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
