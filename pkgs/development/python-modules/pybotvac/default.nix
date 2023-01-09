{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, requests-oauthlib
, voluptuous
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SXIs9AUXWm1H49MVDT4z6msNPaW5sAU20rcsWZ7ERdU=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    voluptuous
  ];

  # Module no tests
  doCheck = false;

  pythonImportsCheck = [
    "pybotvac"
  ];

  meta = with lib; {
    description = "Python module for interacting with Neato Botvac Connected vacuum robots";
    homepage = "https://github.com/stianaske/pybotvac";
    changelog = "https://github.com/stianaske/pybotvac/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
