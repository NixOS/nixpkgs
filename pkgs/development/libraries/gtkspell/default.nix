{stdenv, fetchurl, gtk, aspell, pkgconfig}:

stdenv.mkDerivation {
  name = "gtkspell-2.0.11";
  
  src = fetchurl {
    url = http://gtkspell.sourceforge.net/download/gtkspell-2.0.11.tar.gz;
    md5 = "494869f67146a12a3f17a958f51aeb05";
  };
  
  buildInputs = [aspell pkgconfig gtk];
}
