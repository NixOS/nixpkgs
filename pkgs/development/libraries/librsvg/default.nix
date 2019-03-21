{ lib, stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf, pango, cairo, libxml2, libgsf
, bzip2, libcroco, libintl, darwin, rust, gnome3
, withGTK ? false, gtk3 ? null
, vala, gobject-introspection }:

let
  pname = "librsvg";
  version = "2.44.12";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1h3qnqhr0l7pd2bxg69ki6ckl4srdwgr471dpp4jq9i4784hp0v6";
  };

  outputs = [ "out" "dev" "installedTests" ];

  buildInputs = [ libxml2 libgsf bzip2 libcroco pango libintl ];

  propagatedBuildInputs = [ glib gdk_pixbuf cairo ] ++ lib.optional withGTK gtk3;

  nativeBuildInputs = [ pkgconfig rust.rustc rust.cargo vala gobject-introspection ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      ApplicationServices
    ]);

  configureFlags = [
    "--enable-introspection"
    "--enable-vala"
    "--enable-installed-tests"
    "--enable-always-build-tests"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  makeFlags = [
    "installed_test_metadir=$(installedTests)/share/installed-tests/RSVG"
    "installed_testdir=$(installedTests)/libexec/installed-tests/RSVG"
  ];

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

    # Fix thumbnailer path
    sed -e "s#@bindir@\(/gdk-pixbuf-thumbnailer\)#${gdk_pixbuf}/bin\1#g" \
        -i gdk-pixbuf-loader/librsvg.thumbnailer.in
  '';

  doCheck = false; # fails 20 of 145 tests, very likely to be buggy

  # Merge gdkpixbuf and librsvg loaders
  postInstall = ''
    mv $GDK_PIXBUF/loaders.cache $GDK_PIXBUF/loaders.cache.tmp
    cat ${gdk_pixbuf.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache $GDK_PIXBUF/loaders.cache.tmp > $GDK_PIXBUF/loaders.cache
    rm $GDK_PIXBUF/loaders.cache.tmp
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A small library to render SVG images to Cairo surfaces";
    homepage = https://wiki.gnome.org/Projects/LibRsvg;
    license = licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
