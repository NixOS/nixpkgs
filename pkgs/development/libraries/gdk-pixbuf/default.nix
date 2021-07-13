{ stdenv
, fetchurl
, nixosTests
, fixDarwinDylibNames
, meson
, ninja
, pkg-config
, gettext
, python3
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_43
, gi-docgen
, glib
, libtiff
, libjpeg
, libpng
, gnome
, gobject-introspection
, doCheck ? false
, makeWrapper
, lib
}:

let
  withGtkDoc = stdenv.buildPlatform == stdenv.hostPlatform;
in
stdenv.mkDerivation rec {
  pname = "gdk-pixbuf";
  version = "2.42.6";

  outputs = [ "out" "dev" "man" ]
    ++ lib.optional withGtkDoc "devdoc"
    ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) "installedTests";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zz7pmw2z46g7mr1yjxbsdldd5pd03xbjc58inj8rxfqgrdvg9n4";
  };

  patches = [
    # Move installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    python3
    gobject-introspection
    makeWrapper
    glib
    gi-docgen

    # for man pages
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  propagatedBuildInputs = [
    glib
    libtiff
    libjpeg
    libpng
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString withGtkDoc}"
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dgio_sniffing=false"
  ];

  postPatch = ''
    chmod +x build-aux/* # patchShebangs only applies to executables
    patchShebangs build-aux

    substituteInPlace tests/meson.build --subst-var-by installedtestsprefix "$installedTests"
  '';

  preInstall = ''
    PATH=$PATH:$out/bin # for install script
  '';

  postInstall =
    ''
      # All except one utility seem to be only useful during building.
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"

    '' + lib.optionalString stdenv.isDarwin ''
      # meson erroneously installs loaders with .dylib extension on Darwin.
      # Their @rpath has to be replaced before gdk-pixbuf-query-loaders looks at them.
      for f in $out/${passthru.moduleDir}/*.dylib; do
          install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
          mv $f ''${f%.dylib}.so
      done
    '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
      # We need to install 'loaders.cache' in lib/gdk-pixbuf-2.0/2.10.0/
      $dev/bin/gdk-pixbuf-query-loaders --update-cache
    '' + lib.optionalString withGtkDoc ''
      # So that devhelp can find this.
      mkdir -p "$devdoc/share/devhelp"
      mv "$out/share/doc" "$devdoc/share/devhelp/books"
    '';

  # The fixDarwinDylibNames hook doesn't patch binaries.
  preFixup = lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/* $dev/bin/*; do
        install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
    done
  '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit doCheck;

  setupHook = ./setup-hook.sh;

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };

    tests = {
      installedTests = nixosTests.installed-tests.gdk-pixbuf;
    };

    # gdk_pixbuf_moduledir variable from gdk-pixbuf-2.0.pc
    moduleDir = "lib/gdk-pixbuf-2.0/2.10.0/loaders";
  };

  meta = with lib; {
    description = "A library for image loading and manipulation";
    homepage = "https://gitlab.gnome.org/GNOME/gdk-pixbuf";
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
