{ stdenv, fetchurl, fetchpatch, fixDarwinDylibNames, meson, ninja, pkgconfig, gettext, python3, libxml2, libxslt, docbook_xsl
, docbook_xml_dtd_43, gtk-doc, glib, libtiff, libjpeg, libpng, libX11, gnome3
, jasper, gobject-introspection, doCheck ? false, makeWrapper }:

let
  pname = "gdk-pixbuf";
  version = "2.38.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0fmbjgjcyym3qg46f64qgl7icdm4ii77flyc1mhk244rp8vgi7zi";
  };

  patches = [
    # Move installed tests to a separate output
    ./installed-tests-path.patch
  ];

  outputs = [ "out" "dev" "man" "devdoc" "installedTests" ];

  setupHook = ./setup-hook.sh;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext python3 libxml2 libxslt docbook_xsl docbook_xml_dtd_43
    gtk-doc gobject-introspection makeWrapper
  ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  mesonFlags = [
    "-Ddocs=true"
    "-Djasper=true"
    "-Dx11=true"
    "-Dgir=${if gobject-introspection != null then "true" else "false"}"
    "-Dgio_sniffing=false"
  ];

  postPatch = ''
    chmod +x build-aux/* # patchShebangs only applies to executables
    patchShebangs build-aux

    substituteInPlace tests/meson.build --subst-var-by installedtestsprefix "$installedTests"
  '';

  postInstall =
    # meson erroneously installs loaders with .dylib extension on Darwin.
    # Their @rpath has to be replaced before gdk-pixbuf-query-loaders looks at them.
    stdenv.lib.optionalString stdenv.isDarwin ''
      for f in $out/${passthru.moduleDir}/*.dylib; do
          install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
          mv $f ''${f%.dylib}.so
      done
    ''
    # All except one utility seem to be only useful during building.
    + ''
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"

      # We need to install 'loaders.cache' in lib/gdk-pixbuf-2.0/2.10.0/
      $dev/bin/gdk-pixbuf-query-loaders --update-cache
    '';

  # The fixDarwinDylibNames hook doesn't patch binaries.
  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/* $dev/bin/*; do
        install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
    done
  '';

  preInstall = ''
    PATH=$PATH:$out/bin # for install script
  '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit doCheck;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gdk_pixbuf";
    };

    # gdk_pixbuf_moduledir variable from gdk-pixbuf-2.0.pc
    moduleDir = "lib/gdk-pixbuf-2.0/2.10.0/loaders";
  };

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
