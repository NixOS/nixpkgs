{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, libgweather
, geoclue2
, geocode-glib
, python3
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
  version = "42.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "TTNcGt7tjqLjSuHmt5uVtlFpaHsmjjlsek4l9+rZdlE=";
  };

  patches = [
    # Fix postinstall referring to gtk-update-icon-cache
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-calendar/-/commit/b7e84c432664f76f10680c04781ab5c3cafdd247.patch";
      sha256 = "ahJwspsnU6uT0mc1W+aWPWgp/9+lVF8H+dAK/IV7qgM=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
    wrapGAppsHook4
    python3
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
