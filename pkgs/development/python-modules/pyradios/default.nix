{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, requests
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyradios";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Uqg/owmf2popAhyanAUIdSWpXAGCWkQja4P944BpNhc=";
  };

  propagatedBuildInputs = [
    appdirs
    requests
    setuptools
  ];

  # Tests and pythonImportsCheck require network access
  doCheck = false;

  meta = with lib; {
    description = "Python client for the https://api.radio-browser.info";
    homepage = "https://github.com/andreztz/pyradios";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
