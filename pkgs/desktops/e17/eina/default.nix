{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "eina-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "0kd4116njrbag9h459cmfpg07c4ag04z3yrsg513lpi27amch27w";
  };
  meta = {
    description = "Enlightenment's core data structure library";
    longDescription = ''
      Enlightenment's Eina is a core data structure and common utility
      library.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.lgpl21;
  };
}
