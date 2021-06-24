{ lib, buildPythonPackage, fetchPypi, appdirs, requests }:
buildPythonPackage rec {
  pname = "pyradios";
  version = "0.0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bgfb8vz7jybswss16pdzns0qpqfrwa9f2g8qrh1r4mig4xh2dmi";
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
