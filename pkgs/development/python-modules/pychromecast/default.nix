{ lib, fetchurl, buildPythonPackage, requests, six, zeroconf, protobuf }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "2.0.0";
  name = pname + "-" + version;

  src = fetchurl {
    url    = "mirror://pypi/p/pychromecast/${name}.tar.gz";
    sha256 = "1cp1ssfb8zk4sz74nsnf72b7dd5fzkwc4qdgc7rq8nfr4v611w6c";
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
