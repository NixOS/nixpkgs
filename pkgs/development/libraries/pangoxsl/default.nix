{stdenv, fetchurl, pkgconfig, glib, pango}:

stdenv.mkDerivation {
  name = "pangoxsl-1.6.0.3";
  src = fetchurl {
    url = mirror://sourceforge/pangopdf/pangoxsl-1.6.0.3.tar.gz;
    md5 = "c98bad47ffa7de2e946a8e35d45e071c";
  };

  buildInputs = [
    pkgconfig
    glib
    pango
  ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
