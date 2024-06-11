{ stdenv
, lib
, fetchurl
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, exiv2
, glib
, gnome
, gobject-introspection
, vala
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, python3
}:

stdenv.mkDerivation rec {
  pname = "gexiv2";
  version = "0.14.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Kgyc9I++izQ1AIhm/9QLjt2wZn0iErQjlv32iOk84L4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.pygobject3 ]))
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
  ];

  propagatedBuildInputs = [
    exiv2
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dtests=true"
  ];

  doCheck = true;

  preCheck = let
    libSuffix = if stdenv.isDarwin then "2.dylib" else "so.2";
  in ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running unit tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p $out/lib
    ln -s $PWD/gexiv2/libgexiv2.${libSuffix} $out/lib/libgexiv2.${libSuffix}
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gexiv2";
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
