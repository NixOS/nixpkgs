{ stdenv, fetchurl }:

let
  name = "log4cplus-2.0.5";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "05gb0crf440da3vcaxavglzvsldw8hsvxq3xvvj73mzniv3bz3dk";
  };

  meta = {
    homepage = http://log4cplus.sourceforge.net/;
    description = "A port the log4j library from Java to C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
