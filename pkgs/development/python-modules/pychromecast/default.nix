{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "9.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "883d6e836ff5f1068a8bd00364a15b4c9854293086495e9fd9cacd9b4d54c0bf";
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
