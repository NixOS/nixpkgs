{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, requests-oauthlib
, voluptuous
}:

buildPythonPackage rec {
  pname = "${version}";
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
