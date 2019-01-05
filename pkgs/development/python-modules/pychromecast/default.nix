{ lib, fetchurl, buildPythonPackage, requests, six, zeroconf, protobuf, casttube }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "2.3.0";
  name = pname + "-" + version;

  src = fetchurl {
    url    = "mirror://pypi/p/pychromecast/${name}.tar.gz";
    sha256 = "f385168e34d2ef47f976c8e41bad2f58f5ca004634c0ccb1a12623d8beb2fa38";
  };

  propagatedBuildInputs = [ requests six zeroconf protobuf casttube ];

  meta = with lib; {
    description = "Library for Python 2 and 3 to communicate with the Google Chromecast";
    homepage    = https://github.com/balloob/pychromecast;
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.linux;
  };
}
