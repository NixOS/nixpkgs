{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4e579cbaf6e2285ebf3a9e84019459b4367636bac079ba169527e582fca48b4";
  };

  meta = with stdenv.lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
