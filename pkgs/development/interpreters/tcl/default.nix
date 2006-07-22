{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "tcl-8.4.13";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/tcl/tcl8.4.13-src.tar.gz;
    md5 = "c6b655ad5db095ee73227113220c0523";
  };
}
