{ stdenv
, lib
, fetchurl
, substituteAll
, gettext
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gnome
, accountsservice
, fontconfig
, gdm
, geoclue2
, geocode-glib_2
, glib
, gnome-desktop
, gnome-online-accounts
, gtk3
, gtk4
, libgweather
, json-glib
, krb5
, libpwquality
, librest_1_0
, libsecret
, networkmanager
, pango
, polkit
, webkitgtk_5_0
, systemd
, libadwaita
, libnma-gtk4
, tzdata
, libgnomekbd
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-initial-setup";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1TiUryxad8/IMfeKK7jaTr34VL+0NYviWXDmZ7eIXro=";
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
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    fontconfig
    gdm
    geoclue2
    geocode-glib_2
    glib
    gnome-desktop
    gnome-online-accounts
    gsettings-desktop-schemas
    gtk3
    gtk4
    json-glib
    krb5
    libgweather
    libadwaita
    libnma-gtk4
    libpwquality
    librest_1_0
    libsecret
    networkmanager
    pango
    polkit
    webkitgtk_5_0
  ];

  mesonFlags = [
    "-Dibus=disabled"
    "-Dparental_controls=disabled"
    "-Dvendor-conf-file=${./vendor.conf}"
  ];

  PKG_CONFIG_SYSTEMD_SYSUSERSDIR = "${placeholder "out"}/lib/sysusers.d";

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
