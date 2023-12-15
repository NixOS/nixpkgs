{ lib, stdenv
, fetchurl
, gettext
, itstool
, libxml2
, pkg-config
, gnome-panel
, gtk3
, glib
, libwnck
, libgtop
, libnotify
, upower
, wirelesstools
, linuxPackages
, adwaita-icon-theme
, libgweather
, gucharmap
, tracker
, polkit
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-applets";
  version = "3.50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "b3kagx8WQ+YvOJ7sCLHqPfHzr+1DqzQJb6Ic+njcgKU=";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    libxml2
  ];

  buildInputs = [
    gnome-panel
    gtk3
    glib
    libxml2
    libwnck
    libgtop
    libnotify
    upower
    adwaita-icon-theme
    libgweather
    gucharmap
    tracker
    polkit
    wirelesstools
    linuxPackages.cpupower
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to install modules to gnome panel's directory, as it's read only
  PKG_CONFIG_LIBGNOME_PANEL_MODULESDIR = "${placeholder "out"}/lib/gnome-panel/modules";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Applets for use with the GNOME panel";
    homepage = "https://wiki.gnome.org/Projects/GnomeApplets";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
