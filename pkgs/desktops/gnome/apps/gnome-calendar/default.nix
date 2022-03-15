{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, libgweather
, geoclue2
, geocode-glib
, gettext
, libxml2
, gnome
, gtk4
, evolution-data-server
, libical
, libsoup
, glib
, gsettings-desktop-schemas
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "gnome-calendar";
  version = "42.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1k2ZG3WbwvdvjJQFicd9gb2oEergo5+9kyoIV/R0eZQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    evolution-data-server # waiting for GTK4 port
    libical
    libsoup
    glib
    libgweather
    geoclue2
    geocode-glib
    gsettings-desktop-schemas
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Calendar";
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
