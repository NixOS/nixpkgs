{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "7.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf2e9fa795ea1e9d0d180adfbdccefd6b4f532eae56f41f15d1a75b323096f51";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests zeroconf protobuf casttube ];

  meta = with lib; {
    description = "Library for Python 3.4+ to communicate with the Google Chromecast";
    homepage    = "https://github.com/balloob/pychromecast";
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
