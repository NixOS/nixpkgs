{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, httpx
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyradios";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XTpw8bgFZo35PJngr9oweU6fY3KAphJsrEhkKzWHLIA=";
  };

  propagatedBuildInputs = [
    appdirs
    httpx
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
