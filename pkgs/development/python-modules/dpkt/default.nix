{ stdenv, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  name = "dpkt-1.8";
  disabled = isPy3k;

  src = fetchurl {
    url = "https://dpkt.googlecode.com/files/${name}.tar.gz";
    sha256 = "01q5prynymaqyfsfi2296xncicdpid2hs3yyasim8iigvkwy4vf5";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = https://code.google.com/p/dpkt/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
