{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "lmnotify";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cCP7BU2f7QJe9gAI298cvkp3OGijvBv8G1RN7qfZ5PE=";
  };

  propagatedBuildInputs = [ oauthlib requests requests_oauthlib ];

  doCheck = false; # no tests exist

  pythonImportsCheck = [ "lmnotify" ];

  meta = with lib; {
    description = "Python package for sending notifications to LaMetric Time";
    homepage = "https://github.com/keans/lmnotify";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
