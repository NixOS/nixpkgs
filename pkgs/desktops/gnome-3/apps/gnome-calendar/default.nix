{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
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
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0cs7ggj88n8sira5vzsijmzl3fmflic48lbis24r1d9blx944s63";
  };

  patches = [
    # Port to libhandy-1
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-calendar/-/commit/8be361b6ce8f0f8053e1609decbdbdc164ec8448.patch";
      sha256 = "Ue0pWwcbYyCZPHPPoR0dXW5n948/AZ3wVDMTIZDOnyE=";
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
    pkgconfig
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

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Calendar";
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
