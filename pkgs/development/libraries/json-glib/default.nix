{ lib
, stdenv
, fetchurl
, glib
, meson
, ninja
, pkg-config
, gettext
, gobject-introspection
, fixDarwinDylibNames
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "json-glib";
  version = "1.6.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "092g2dyy1hhl0ix9kp33wcab0pg1qicnsv0cj5ms9g9qs336cgd3";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    glib
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optional stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  propagatedBuildInputs = [
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
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
