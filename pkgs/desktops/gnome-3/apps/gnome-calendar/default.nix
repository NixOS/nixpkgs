{ lib, stdenv
, fetchurl
, fetchpatch
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
, gnome3
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
  version = "40.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "02cf7ckjfgb7n4wqc55gis3r8shv4hq0ckrilc52d0p79qsmak6w";
  };

  patches = [
    # Port to libhandy-1
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-calendar/-/commit/8be361b6ce8f0f8053e1609decbdbdc164ec8448.patch";
      sha256 = "Ue0pWwcbYyCZPHPPoR0dXW5n948/AZ3wVDMTIZDOnyE=";
    })

    # https://gitlab.gnome.org/GNOME/gnome-calendar/-/merge_requests/84
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-calendar/-/merge_requests/84.patch";
      sha256 = "czG3uIHl3tBnjDUvCOPm8IRp2o7yZYCb0/jWtv3uzIY=";
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
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
