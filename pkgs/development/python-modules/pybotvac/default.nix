{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests-oauthlib
, voluptuous
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.23";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VLT+VlwQAAxU1WRNCB4t4fhQ2u+6w5zqdM6mSbR7+xI=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    voluptuous
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "pybotvac"
  ];

  meta = with lib; {
    description = "Python module for interacting with Neato Botvac Connected vacuum robots";
    homepage = "https://github.com/stianaske/pybotvac";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
