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
, rustPlatform
, rustc
, rust
, cargo
, gi-docgen
, python3Packages
, gnome
, vala
, withIntrospection ? stdenv.hostPlatform == stdenv.buildPlatform
, gobject-introspection
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "librsvg";
  version = "2.54.4";

  outputs = [ "out" "dev" "installedTests" ] ++ lib.optionals withIntrospection [
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "6hUqJD9qQ8DgNqKMcN4/y83qVmTGgRx4WSvCKezCSDM=";
  };

  cargoVendorDir = "vendor";

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    gdk-pixbuf
    pkg-config
    rustc
    cargo
    python3Packages.docutils
    vala
    rustPlatform.cargoSetupHook
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    libxml2
    bzip2
    pango
    libintl
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Foundation
    libobjc
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    cairo
  ];

  configureFlags = [
    (lib.enableFeature withIntrospection "introspection")

    # Vapi does not build on MacOS.
    # https://github.com/NixOS/nixpkgs/pull/117081#issuecomment-827782004
    (lib.enableFeature (withIntrospection && !stdenv.isDarwin) "vala")

    "--enable-installed-tests"
    "--enable-always-build-tests"
  ] ++ lib.optional stdenv.isDarwin "--disable-Bsymbolic"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "RUST_TARGET=${rust.toRustTarget stdenv.hostPlatform}";

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

    # 'error: linker `cc` not found' when cross-compiling
    export RUSTFLAGS="-Clinker=$CC"
  '';

  # Not generated when cross compiling.
  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    # Merge gdkpixbuf and librsvg loaders
    cat ${lib.getLib gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache $GDK_PIXBUF/loaders.cache > $GDK_PIXBUF/loaders.cache.tmp
    mv $GDK_PIXBUF/loaders.cache.tmp $GDK_PIXBUF/loaders.cache
  '';

  postFixup = lib.optionalString withIntrospection ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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
    mainProgram = "rsvg-convert";
    platforms = platforms.unix;
  };
}
