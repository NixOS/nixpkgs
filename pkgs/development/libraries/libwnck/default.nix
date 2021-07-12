{ lib, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, libX11
, glib
, gtk3
, pango
, cairo
, libXres
, libstartup_notification
, gettext
, gobject-introspection
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libwnck";
  version = "3.36.0";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0pwjdhca9lz2n1gf9b60xf0m6ipf9snp8rqf9csj4pgdnd882l5w";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    libX11
    libstartup_notification
    pango
    cairo
    libXres
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "${pname}${lib.versions.major version}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ liff ];
  };
}
