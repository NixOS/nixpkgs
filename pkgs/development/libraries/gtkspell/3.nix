{stdenv, fetchurl, gtk3, aspell, pkgconfig, enchant, isocodes, intltool, gobjectIntrospection}:

stdenv.mkDerivation rec {
  name = "gtkspell-${version}";
  version = "3.0.9";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell3-${version}.tar.xz";
    sha256 = "09jdicmpipmj4v84gnkqwbmj4lh8v0i6pn967rb9jx4zg2ia9x54";
  };

  nativeBuildInputs = [ pkgconfig intltool gobjectIntrospection ];
  buildInputs = [ aspell gtk3 enchant isocodes ];
  propagatedBuildInputs = [ enchant ];

  configureFlags = [ "--enable-introspection" ];

  meta = with stdenv.lib; {
    homepage = http://gtkspell.sourceforge.net/;
    description = "Word-processor-style highlighting GtkTextView widget";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
  };
}
