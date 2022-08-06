{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk4
, desktop-file-utils
, wrapGAppsHook4
, gettext
, itstool
, libadwaita
, libxml2
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_43
, systemd
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "naBuiFhl7dG/vPILLU6HwVAGUXKdZW//E77pNlCTldQ=";
  };

  patches = [
    # Remove GTK 3 depndency
    # https://gitlab.gnome.org/GNOME/gnome-logs/-/merge_requests/46
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-logs/-/commit/f7fe4b6ff9f5ab70919b6747f95e38d0d48685b8.patch";
      sha256 = "yZY7qYWkJrArqeu1E2xxbJnPggaxOG3sk7212PqMcpo=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    glib
    gtk4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    systemd
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dman=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome.gnome-logs";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Logs";
    description = "A log viewer for the systemd journal";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
