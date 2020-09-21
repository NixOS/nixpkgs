{ stdenv
, fetchurl
, substituteAll
, gettext
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, gnome3
, accountsservice
, fontconfig
, gdm
, geoclue2
, geocode-glib
, glib
, gnome-desktop
, gnome-getting-started-docs
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
, yelp
, libgnomekbd
, gsettings-desktop-schemas
, gnome-tour
}:

stdenv.mkDerivation rec {
  pname = "gnome-initial-setup";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-OoV67177aJ9AhjLbhGmtJ2IPdi2XcHCjYDXFIsb4J1k=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
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
    gnome-getting-started-docs
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

  patches = [
    (substituteAll {
      src = ./0001-fix-paths.patch;
      inherit tzdata libgnomekbd;
      gnome_tour = "${gnome-tour}/bin/gnome-tour";
    })
  ];

  mesonFlags = [
    "-Dcheese=disabled"
    "-Dibus=disabled"
    "-Dparental_controls=disabled"
    "-Dvendor-conf-file=${./vendor.conf}"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Simple, easy, and safe way to prepare a new system";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-initial-setup";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
