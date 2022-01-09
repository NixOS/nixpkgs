{ lib, buildPythonPackage, fetchPypi, appdirs, requests }:
buildPythonPackage rec {
  pname = "pyradios";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fd3b234c635d9e628bdadb9dc3a820405631b54977402719a641d2e1cc3f7b6";
  };

  propagatedBuildInputs = [
    appdirs
    requests
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python client for the https://api.radio-browser.info";
    homepage = "https://github.com/andreztz/pyradios";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
