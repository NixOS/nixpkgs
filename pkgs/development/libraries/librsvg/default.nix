{stdenv, fetchurl, pkgconfig, libxml2, libgsf, bzip2, glib, gtk, libcroco}:

stdenv.mkDerivation {
  name = "librsvg-2.34.2";

  src = fetchurl {
    url = mirror://gnome/sources/librsvg/2.34/librsvg-2.34.2.tar.xz;
    sha256 = "0r24xr10chmz4l3ka2zy9c2245s7svzljbw9nrda3h44bcr03rsx";
  };
  buildInputs = [ libxml2 libgsf bzip2 libcroco ];
  propagatedBuildInputs = [ glib gtk ];
  nativeBuildInputs = [ pkgconfig ];

  # It wants to add loaders and update the loaders.cache in gdk-pixbuf
  # Patching the Makefiles to it creates rsvg specific loaders and the
  # relevant loader.cache here.
  # The loaders.cache can be used by setting GDK_PIXBUF_MODULE_FILE to
  # point to this file in a wrapper.
  postConfigure = ''
    GDK_PIXBUF=$out/lib/gdk-pixbuf
    mkdir -p $GDK_PIXBUF/loaders
    sed -e "s#gdk_pixbuf_moduledir = .*#gdk_pixbuf_moduledir = $GDK_PIXBUF/loaders#" \
        -i gdk-pixbuf-loader/Makefile
    sed -e "s#gdk_pixbuf_cache_file = .*#gdk_pixbuf_cache_file = $GDK_PIXBUF/loaders.cache#" \
        -i gdk-pixbuf-loader/Makefile
    sed -e "s#\$(GDK_PIXBUF_QUERYLOADERS)#GDK_PIXBUF_MODULEDIR=$GDK_PIXBUF/loaders \$(GDK_PIXBUF_QUERYLOADERS)#" \
         -i gdk-pixbuf-loader/Makefile
  '';
}
