{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fhh3djb6chs23j46hwzm1rd6hypkl517vjmmg44rxnslkcl7dhb";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests zeroconf protobuf casttube ];

  meta = with lib; {
    description = "Library for Python 3.4+ to communicate with the Google Chromecast";
    homepage    = https://github.com/balloob/pychromecast;
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
