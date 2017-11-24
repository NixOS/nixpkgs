{ lib, fetchurl, buildPythonPackage, requests, six, zeroconf, protobuf }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "0.8.1";
  name = pname + "-" + version;

  src = fetchurl {
    url    = "mirror://pypi/p/pychromecast/${name}.tar.gz";
    sha256 = "05rlr2hjng0xg2a9k9vwmrlvd7vy9sjhxxfl96kx25xynlkq6yq6";
  };

  propagatedBuildInputs = [ requests six zeroconf protobuf ];

  meta = with lib; {
    description = "Library for Python 2 and 3 to communicate with the Google Chromecast";
    homepage    = "https://github.com/balloob/pychromecast";
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.linux;
  };
}
