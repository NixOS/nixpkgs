{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "141cab4defcb4ead83e664765ebb045f55dbe73e17d617acafd6eaf368d7c55e";
  };

  meta = with lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
