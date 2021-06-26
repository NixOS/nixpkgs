{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_oauthlib
, voluptuous
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hf692w44dmalv7hlcpwzbnr6xhvnmdv5nl1jcy2jhiwp89lkhzv";
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
