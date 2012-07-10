{ stdenv, fetchurl, pkgconfig, gnome3, libtiff, libjpeg, libpng, libX11, xz, jasper }:

stdenv.mkDerivation rec {
  versionMajor = "2.26";
  versionMinor = "1";

  name = "gdk-pixbuf-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${versionMajor}/gdk-pixbuf-${versionMajor}.${versionMinor}.tar.xz";
    sha256 = "1fn79r5vk1ck6xd5f7dgckbfhf2xrqq6f3389jx1bk6rb0mz22m6";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 ];

  buildNativeInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gnome3.glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11";

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A library for image loading and manipulation";

    homepage = http://library.gnome.org/devel/gdk-pixbuf/;

    maintainers = [ stdenv.lib.maintainers.antono ];
    platforms = stdenv.lib.platforms.linux;
  };
}
