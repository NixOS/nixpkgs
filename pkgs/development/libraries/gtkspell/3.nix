{stdenv, fetchurl, gtk3, aspell, pkgconfig, enchant, intltool}:

stdenv.mkDerivation rec {
  name = "gtkspell-${version}";
  version = "3.0.8";

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell3-${version}.tar.gz";
    sha256 = "1zrz5pz4ryvcssk898liynmy2wyxgj95ak7mp2jv7x62yzihq6h1";
  };

  buildInputs = [ aspell pkgconfig gtk3 enchant intltool ];
  propagatedBuildInputs = [ enchant ];

  meta = {
    homepage = "http://gtkspell.sourceforge.net/";
    description = "Word-processor-style highlighting GtkTextView widget";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
