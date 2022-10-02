{ lib
, stdenv
, gettext
, fetchurl
, evolution-data-server
, pkg-config
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, desktop-file-utils
, gtk4
, glib
, libportal
, gnome-desktop
, gnome-online-accounts
, wrapGAppsHook
, folks
, libgdata
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
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "iALDj9wj9SjawSj1O9zx9sow4OHGhIxCzWyEpeIsUhY=";
  };

  propagatedUserEnvPkgs = [
    evolution-data-server
  ];

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
    wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    glib
    libportal
    evolution-data-server
    gsettings-desktop-schemas
    folks
    gnome-desktop
    libadwaita
    libxml2
    gnome-online-accounts
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
