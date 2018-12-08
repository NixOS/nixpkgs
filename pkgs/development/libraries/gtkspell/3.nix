{stdenv, fetchurl, gtk3, aspell, pkgconfig, enchant2, isocodes, intltool, gobject-introspection, vala}:

stdenv.mkDerivation rec {
  name = "gtkspell-${version}";
  version = "3.0.10";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell3-${version}.tar.xz";
    sha256 = "0cjp6xdcnzh6kka42w9g0w2ihqjlq8yl8hjm9wsfnixk6qwgch5h";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection vala ];
  buildInputs = [ aspell gtk3 enchant2 isocodes ];
  propagatedBuildInputs = [ enchant2 ];

  configureFlags = [
    "--enable-introspection"
    "--enable-vala"
  ];

  meta = with stdenv.lib; {
    homepage = http://gtkspell.sourceforge.net/;
    description = "Word-processor-style highlighting GtkTextView widget";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fuuzetsu ];
  };
}
