{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m0ym219zsqfjl6jwivw5as3igjbmhpcn4dvabc5nkd0bk6jxaaj";
  };

  meta = with stdenv.lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = https://code.google.com/p/dpkt/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
