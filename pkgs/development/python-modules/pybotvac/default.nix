{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_oauthlib
, voluptuous
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1NnTSO4vO3Ryt4vYD5ZTQGr241GqA2KsGRBVowSTCzM=";
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
