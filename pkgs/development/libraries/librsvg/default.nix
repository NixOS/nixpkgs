{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, gdk-pixbuf
, pango
, cairo
, libxml2
, bzip2
, libintl
, ApplicationServices
, Foundation
, libobjc
, rustc
, cargo
, gnome
, vala
, gobject-introspection
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "librsvg";
  version = "2.50.7";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "//thsIzVKCqq4UegKzBRZqdCb60iqLlCdwjw8vxCbrw=";
  };

  nativeBuildInputs = [
    pkg-config
    rustc
    cargo
    vala
    gobject-introspection
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Foundation
  ];

  buildInputs = [
    libxml2
    bzip2
    pango
    libintl
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    cairo
  ];

  configureFlags = [
    "--enable-introspection"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # Vapi does not build on MacOS.
    # https://github.com/NixOS/nixpkgs/pull/117081#issuecomment-827782004
    "--enable-vala"
  ] ++ [
    "--enable-installed-tests"
    "--enable-always-build-tests"
  ] ++ lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  makeFlags = [
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/RSVG"
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/RSVG"
  ];

  doCheck = false; # all tests fail on libtool-generated rsvg-convert not being able to find coreutils

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
    sed -e "s#@bindir@\(/gdk-pixbuf-thumbnailer\)#${gdk-pixbuf}/bin\1#g" \
        -i gdk-pixbuf-loader/librsvg.thumbnailer.in
  '';

  # Merge gdkpixbuf and librsvg loaders
  postInstall = ''
    mv $GDK_PIXBUF/loaders.cache $GDK_PIXBUF/loaders.cache.tmp
    cat ${gdk-pixbuf.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache $GDK_PIXBUF/loaders.cache.tmp > $GDK_PIXBUF/loaders.cache
    rm $GDK_PIXBUF/loaders.cache.tmp
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };

    tests = {
      installedTests = nixosTests.installed-tests.librsvg;
    };
  };

  meta = with lib; {
    description = "A small library to render SVG images to Cairo surfaces";
    homepage = "https://wiki.gnome.org/Projects/LibRsvg";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
