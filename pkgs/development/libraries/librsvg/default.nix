{ lib, stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf, pango, cairo, libxml2, libgsf
, bzip2, libcroco, libintlOrEmpty
, withGTK ? false, gtk3 ? null
, gobjectIntrospection ? null, enableIntrospection ? false }:

# no introspection by default, it's too big

stdenv.mkDerivation rec {
  name = "librsvg-2.40.9";

  src = fetchurl {
    url    = "mirror://gnome/sources/librsvg/2.40/${name}.tar.xz";
    sha256 = "0fplymmqqr28y24vcnb01szn62pfbqhk8p1ngns54x9m6mflr5hk";
  };

  NIX_LDFLAGS = if stdenv.isDarwin then "-lintl" else null;

  buildInputs = [ libxml2 libgsf bzip2 libcroco pango libintlOrEmpty ]
    ++ stdenv.lib.optional enableIntrospection [ gobjectIntrospection ];

  propagatedBuildInputs = [ glib gdk_pixbuf cairo ] ++ lib.optional withGTK gtk3;

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--enable-introspection=auto" ]
    ++ stdenv.lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  NIX_CFLAGS_COMPILE
    = stdenv.lib.optionalString stdenv.isDarwin "-I${cairo.dev}/include/cairo";

  # It wants to add loaders and update the loaders.cache in gdk-pixbuf
  # Patching the Makefiles to it creates rsvg specific loaders and the
  # relevant loader.cache here.
  # The loaders.cache can be used by setting GDK_PIXBUF_MODULE_FILE to
  # point to this file in a wrapper.
  postConfigure = ''
    GDK_PIXBUF=$out/lib/gdk-pixbuf-2.0/2.10.0
    mkdir -p $GDK_PIXBUF/loaders
    sed -e "s#gdk_pixbuf_moduledir = .*#gdk_pixbuf_moduledir = $GDK_PIXBUF/loaders#" \
        -i gdk-pixbuf-loader/Makefile
    sed -e "s#gdk_pixbuf_cache_file = .*#gdk_pixbuf_cache_file = $GDK_PIXBUF/loaders.cache#" \
        -i gdk-pixbuf-loader/Makefile
    sed -e "s#\$(GDK_PIXBUF_QUERYLOADERS)#GDK_PIXBUF_MODULEDIR=$GDK_PIXBUF/loaders \$(GDK_PIXBUF_QUERYLOADERS)#" \
         -i gdk-pixbuf-loader/Makefile
  '';

  # Merge gdkpixbuf and librsvg loaders
  postInstall = ''
    mv $GDK_PIXBUF/loaders.cache $GDK_PIXBUF/loaders.cache.tmp
    cat ${gdk_pixbuf.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache $GDK_PIXBUF/loaders.cache.tmp > $GDK_PIXBUF/loaders.cache
    rm $GDK_PIXBUF/loaders.cache.tmp
  '';
}
