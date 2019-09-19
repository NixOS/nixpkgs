{ stdenv
, fetchurl
, fetchpatch
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
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19ly8xrj7vvjlhhbh6y2cm5l02qgq9wqfczrjdn0llkga9f8b8sc";
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
    # Disable g-i-s service in GDM
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-initial-setup/commit/b67b5cc48c418415eb3233f78ab089bc447b1952.patch";
      sha256 = "050zc6cnil71bf7ijav6w6bkr33lqwglipcg7anw9jcn7mcakhlq";
    })
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
