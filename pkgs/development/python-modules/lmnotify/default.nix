{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, requests
, requests-oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lmnotify";
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cCP7BU2f7QJe9gAI298cvkp3OGijvBv8G1RN7qfZ5PE=";
  };

  propagatedBuildInputs = [
    oauthlib
    requests
    requests-oauthlib
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lmnotify"
  ];

  meta = with lib; {
    description = "Python package for sending notifications to LaMetric Time";
    homepage = "https://github.com/keans/lmnotify";
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
