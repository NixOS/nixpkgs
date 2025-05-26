{
  lib,
  buildPythonPackage,
  fetchPypi,
  appdirs,
  httpx,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyradios";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FRAd1M8JZIsogLa/W78IQddMxG0Z8tAP+IiVtHU9fp4=";
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
    maintainers = [ ];
  };
}
