{ lib
, stdenv
, gettext
, fetchurl
, evolution-data-server-gtk4
, pkg-config
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, desktop-file-utils
, gtk4
, glib
, libportal-gtk4
, gnome-desktop
, gnome-online-accounts
, qrencode
, wrapGAppsHook4
, folks
, libxml2
, gnome
, vala
, meson
, ninja
, libadwaita
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "vR/fKm9kzdnyq7/tB+ZPKmmuNTb3T0gZjMN7rZ/NlD4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    libportal-gtk4
    evolution-data-server-gtk4
    gsettings-desktop-schemas
    folks
    gnome-desktop
    libadwaita
    libxml2
    gnome-online-accounts
    qrencode
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-contacts";
      attrPath = "gnome.gnome-contacts";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Contacts";
    description = "GNOME’s integrated address book";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
