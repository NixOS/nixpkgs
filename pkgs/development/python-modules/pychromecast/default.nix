{ lib, fetchurl, buildPythonPackage, requests, six, zeroconf, protobuf }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "1.0.3";
  name = pname + "-" + version;

  src = fetchurl {
    url    = "mirror://pypi/p/pychromecast/${name}.tar.gz";
    sha256 = "714a9e03e6a258081e3b6296ed15592e015facbe38bbe60819cca6f04c599f25";
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
