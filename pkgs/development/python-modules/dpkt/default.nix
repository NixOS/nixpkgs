{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74899d557ec4e337db29cecc80548b23a1205384d30ee407397cfb9ab178e3d4";
  };

  meta = with lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
