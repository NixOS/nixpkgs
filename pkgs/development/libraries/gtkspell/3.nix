{stdenv, fetchurl, gtk3, aspell, pkgconfig, enchant, intltool}:

stdenv.mkDerivation rec {
  name = "gtkspell-${version}";
  version = "3.0.4";
  
  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell3-${version}.tar.gz";
    sha256 = "19z48gfbraasrxai7qdkxxvky0kwifkkzqz0jqcskhcr1ikqxgzs";
  };
  
  buildInputs = [ aspell pkgconfig gtk3 enchant intltool ];
  propagatedBuildInputs = [ enchant ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
