{ stdenv, fetchurl, pkgconfig, libxml2, libgsf, bzip2, glib, gtk, libcroco
, gdk_pixbuf, gobjectIntrospection?null, enableIntrospection?false }:

# no introspection by default, it's too big

stdenv.mkDerivation rec {
  name = "librsvg-2.36.4";

  src = fetchurl {
    url = "mirror://gnome/sources/librsvg/2.36/${name}.tar.xz";
    sha256 = "1hp6325gdkzx8yqn2d2r915ak3k6hfshjjh0sc54z3vr0i99688h";
  };
  buildInputs = [ libxml2 libgsf bzip2 libcroco gdk_pixbuf ]
    ++ stdenv.lib.optional enableIntrospection [gobjectIntrospection];
  propagatedBuildInputs = [ glib gtk ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = ["--enable-introspection=auto"];

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
