{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11, xz
, jasper, libintlOrEmpty, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-2.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/2.28/${name}.tar.xz";
    sha256 = "05s6ksvy1yan6h6zny9n3bmvygcnzma6ljl6i0z9cci2xg116c8q";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 libintlOrEmpty ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11"
    + stdenv.lib.optionalString (gobjectIntrospection != null) " --enable-introspection=yes"
    ;

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
