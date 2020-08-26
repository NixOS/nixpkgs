{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18jcanxpzkd5n2gjbfpwbvvkm1hpxr59463z28py23vkbx57wmvg";
  };

  meta = with stdenv.lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
