{stdenv, fetchurl, tcl, x11}:

stdenv.mkDerivation {
  name = "tk-8.4.16";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/tcl/tk8.4.16-src.tar.gz;
    sha256 = "0cciavzd05bpm5yfppid0s0vsf8kabwia9620vgvi26sv1gjgwhb";
  };
  buildInputs = [tcl x11];
  inherit tcl;
}
