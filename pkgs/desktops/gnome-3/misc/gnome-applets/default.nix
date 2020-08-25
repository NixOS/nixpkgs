{ stdenv
, fetchurl
, gettext
, itstool
, libxml2
, pkg-config
, gnome-panel
, gtk3
, glib
, libwnck3
, libgtop
, libnotify
, upower
, wirelesstools
, linuxPackages
, adwaita-icon-theme
, libgweather
, gucharmap
, tracker_2
, polkit
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gnome-applets";
  version = "3.37.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0l1mc9ymjg0bgk92a08zd85hx1vaqrzdj0dwzmna20rp51vf0l4a";
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
    libwnck3
    libgtop
    libnotify
    upower
    adwaita-icon-theme
    libgweather
    gucharmap
    tracker_2
    polkit
    wirelesstools
    linuxPackages.cpupower
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to install modules to gnome panel's directory, as it's read only
  PKG_CONFIG_LIBGNOME_PANEL_MODULESDIR = "${placeholder "out"}/lib/gnome-panel/modules";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Applets for use with the GNOME panel";
    homepage = "https://wiki.gnome.org/Projects/GnomeApplets";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
