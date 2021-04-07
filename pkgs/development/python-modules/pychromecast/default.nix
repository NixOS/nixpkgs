{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "9.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q52h0u9CSx/HVfZDb1RaVgVuxt4kB16T82nqyOuCGDc=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests zeroconf protobuf casttube ];

  # no tests available
  doCheck = false;
  pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Library for Python to communicate with the Google Chromecast";
    homepage    = "https://github.com/home-assistant-libs/pychromecast";
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
