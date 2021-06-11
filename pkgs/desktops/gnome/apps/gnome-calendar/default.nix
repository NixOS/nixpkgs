{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, wrapGAppsHook
, libdazzle
, libgweather
, geoclue2
, geocode-glib
, python3
, gettext
, libxml2
, gnome
, gtk3
, evolution-data-server
, libsoup
, glib
, gnome-online-accounts
, gsettings-desktop-schemas
, libhandy
, adwaita-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "gnome-calendar";
  version = "40.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "njcB/UoOWJgA0iUgN3BkTzHVI0ZV9UqDqF/wVW3X6jM=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-calendar/-/merge_requests/84
    # A refactor has caused the PR patch to drift enough to need rebasing
    ./gtk_image_reset_crash.patch
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    evolution-data-server
    libsoup
    glib
    gnome-online-accounts
    libdazzle
    libgweather
    geoclue2
    geocode-glib
    gsettings-desktop-schemas
    adwaita-icon-theme
    libhandy
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Calendar";
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
