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
}:

stdenv.mkDerivation rec {
  pname = "gnome-initial-setup";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "08di7n26qhjfr0p1dvya2xfqwx37k8xbya97a8ccz3j0fzw0my4a";
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
    libnma
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata libgnomekbd;
      yelp = "${yelp}/bin/yelp"; # gnome-welcome-tour
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
    maintainers = gnome3.maintainers;
  };
}
