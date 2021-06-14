{ lib
, stdenv
, fetchurl
, glib
, meson
, ninja
, pkg-config
, gettext
, withIntrospection ? stdenv.buildPlatform == stdenv.hostPlatform
, gobject-introspection
, fixDarwinDylibNames
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, gnome
}:

stdenv.mkDerivation rec {
  pname = "json-glib";
  version = "1.6.2";

  outputs = [ "out" "dev" ]
    ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "092g2dyy1hhl0ix9kp33wcab0pg1qicnsv0cj5ms9g9qs336cgd3";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optional stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    gtk-doc
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = lib.optionals (!withIntrospection) [
    "-Dintrospection=disabled"
    # doc gen uses introspection, doesn't work properly
    "-Dgtk_doc=disabled"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    homepage = "https://wiki.gnome.org/Projects/JsonGlib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = with platforms; unix;
  };
}
