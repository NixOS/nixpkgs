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
, networkmanagerapplet
, tzdata
, yelp
, libgnomekbd
}:

stdenv.mkDerivation rec {
  pname = "gnome-initial-setup";
  version = "3.34.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1dc87mcvr7vdhfx4q0c44q37lf7ls2qvnc34dm66802qssrcxy9k";
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
    gtk3
    json-glib
    krb5
    libgweather
    libpwquality
    librest
    libsecret
    networkmanager
    pango
    polkit
    webkitgtk
    networkmanagerapplet
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata libgnomekbd;
      yelp = "${yelp}/bin/yelp"; # gnome-welcome-tour
    })
  ];

  mesonFlags = [
    "-Dregion-page=true"
    "-Dcheese=disabled"
    "-Dsoftware-sources=disabled"
    "-Dibus=disabled"
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
    maintainers = gnome3.maintainers;
  };
}
