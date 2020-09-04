{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "7.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9aad074d0361791af8ccb8fb7ea0f1646db3d89600fed85c5562b64c8b1aa899";
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
