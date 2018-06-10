{ lib, fetchurl, buildPythonPackage, requests, six, zeroconf, protobuf }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "2.1.0";
  name = pname + "-" + version;

  src = fetchurl {
    url    = "mirror://pypi/p/pychromecast/${name}.tar.gz";
    sha256 = "a18fee9bf32f62fcb539783c3888e811015c1f6377bcdb383b13d6537691f336";
  };

  propagatedBuildInputs = [ requests six zeroconf protobuf ];

  meta = with lib; {
    description = "Library for Python 2 and 3 to communicate with the Google Chromecast";
    homepage    = https://github.com/balloob/pychromecast;
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.linux;
  };
}
