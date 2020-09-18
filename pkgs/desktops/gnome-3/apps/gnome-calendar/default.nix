{ stdenv
, fetchurl
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
