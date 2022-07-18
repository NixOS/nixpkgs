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
  version = "40.1";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "AxNPoRTvP740B1qoNnj1iqLevp/O9OojwHeeKGAdZhE=";
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
    };
  };

  meta = with lib; {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ liff ];
  };
}
