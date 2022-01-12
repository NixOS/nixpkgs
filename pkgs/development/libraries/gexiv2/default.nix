{ stdenv
, lib
, fetchurl
, meson
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
  version = "0.14.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "5YJ5pv8gtvZPpJlhXaXptXz2W6eFC3L6/fFyIanW1p4=";
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
  ];

  buildInputs = [
    glib
    # Python binding overrides
    python3
    python3.pkgs.pygobject3
  ];

  propagatedBuildInputs = [
    exiv2
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dpython3_girdir=${placeholder "out"}/${python3.sitePackages}/gi/overrides"
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
    homepage = "https://wiki.gnome.org/Projects/gexiv2";
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
