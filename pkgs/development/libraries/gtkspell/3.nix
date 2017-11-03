{stdenv, fetchurl, gtk3, aspell, pkgconfig, enchant, intltool}:

stdenv.mkDerivation rec {
  name = "gtkspell-${version}";
  version = "3.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell3-${version}.tar.xz";
    sha256 = "09jdicmpipmj4v84gnkqwbmj4lh8v0i6pn967rb9jx4zg2ia9x54";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ aspell gtk3 enchant ];
  propagatedBuildInputs = [ enchant ];

  meta = with stdenv.lib; {
    homepage = http://gtkspell.sourceforge.net/;
    description = "Word-processor-style highlighting GtkTextView widget";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
  };
}
