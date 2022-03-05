{ lib, stdenv
, fetchurl
, substituteAll
, gettext
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gnome
, accountsservice
, fontconfig
, gdm
, geoclue2
, geocode-glib
, glib
, gnome-desktop
, gnome-online-accounts
, gtk3
, libgweather
, json-glib
, krb5
, libpwquality
, librest
, libsecret
, networkmanager
, pango
, polkit
, webkitgtk
, systemd
, libnma
, tzdata
, libgnomekbd
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-initial-setup";
  version = "41.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "luzS2252xROxjGBtwmK7UjIoxKrtvtageBHlaP1dtkI=";
  };

  patches = [
    (substituteAll {
      src = ./0001-fix-paths.patch;
      inherit tzdata libgnomekbd;
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    systemd
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    fontconfig
    gdm
    geoclue2
    geocode-glib
    glib
    gnome-desktop
    gnome-online-accounts
    gsettings-desktop-schemas
    gtk3
    json-glib
    krb5
    libgweather
    libnma
    libpwquality
    librest
    libsecret
    networkmanager
    pango
    polkit
    webkitgtk
  ];

  mesonFlags = [
    "-Dcheese=disabled"
    "-Dibus=disabled"
    "-Dparental_controls=disabled"
    "-Dvendor-conf-file=${./vendor.conf}"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Simple, easy, and safe way to prepare a new system";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-initial-setup";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
