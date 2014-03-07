{ stdenv, fetchurl, glib, pkgconfig }:

stdenv.mkDerivation {
  name = "menu-cache-0.5.1";
  src = fetchurl {
    url = "mirror://sourceforge/lxde/menu-cache-0.5.1.tar.gz";
    sha256 = "08m1msgbl6j7j72cwcg18klb99jif8h1phkcnbplxkdf3w15irh8";
  };

  buildInputs = [ glib pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?tag=menu-cache";
    license = licenses.gpl2Plus;
    description = "Library to read freedesktop.org menu files";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
