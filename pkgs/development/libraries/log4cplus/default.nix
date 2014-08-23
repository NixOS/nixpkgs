{ stdenv, fetchurl }:

let
  name = "log4cplus-1.1.2";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "14zdfaxnxjrnfdjipmcrvsqp8pj1s4wscphvg4jvbp3kd34mcvf4";
  };

  meta = {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "a port the log4j library from Java to C++";
    license = stdenv.lib.licenses.asl20;
  };
}
