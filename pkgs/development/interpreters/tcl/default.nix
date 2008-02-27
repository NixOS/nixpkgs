{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "tcl-8.4.18";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/tcl/tcl8.4.18-src.tar.gz;
    sha256 = "197h3m2lc5a6famc683zhjp55774gf8zwggfy2893v48lp5p7qny";
  };
  meta = {
    description = "The Tcl scription language";
    homepage = http://www.tcl.tk/;
  };
}
