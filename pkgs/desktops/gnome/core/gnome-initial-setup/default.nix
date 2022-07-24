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
, geocode-glib_2
, glib
, gnome-desktop
, gnome-online-accounts
, gtk3
, libgweather
, json-glib
, krb5
, libpwquality
, librest_1_0
, libsecret
, networkmanager
, pango
, polkit
, webkitgtk_4_1
, systemd
, libhandy
, libnma
, tzdata
, libgnomekbd
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-initial-setup";
  version = "43.alpha.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "40CMKAVdMET/bnDcecI35i6b9lTYh9h7v6Ewo9NHPS8=";
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
    geocode-glib_2
    glib
    gnome-desktop
    gnome-online-accounts
    gsettings-desktop-schemas
    gtk3
    json-glib
    krb5
    libgweather
    libhandy
    libnma
    libpwquality
    librest_1_0
    libsecret
    networkmanager
    pango
    polkit
    webkitgtk_4_1
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
