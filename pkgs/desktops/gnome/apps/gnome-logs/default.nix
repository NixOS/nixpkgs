{ stdenv
, lib
, fetchurl
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
  version = "45.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "nbxJ/7J90jQuji/UmK8ltUENsjkQ/I7/XmiTrHa7jK4=";
  };

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
