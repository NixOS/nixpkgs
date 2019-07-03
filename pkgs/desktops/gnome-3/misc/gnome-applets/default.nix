{ stdenv
, fetchurl
, intltool
, itstool
, libxml2
, libxslt
, pkgconfig
, gnome-panel
, gtk3
, glib
, libwnck3
, libgtop
, libnotify
, upower
, dbus-glib
, wirelesstools
, linuxPackages
, adwaita-icon-theme
, libgweather
, gucharmap
, gnome-settings-daemon
, tracker
, polkit
, gnome3
}:

let
  pname = "gnome-applets";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "10kd19ymxl2z65121g90mx96m6vcn2a8a50g6a56prrdjsgbgia1";
  };

  nativeBuildInputs = [
    intltool
    itstool
    pkgconfig
    libxml2
    libxslt
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
    dbus-glib
    adwaita-icon-theme
    libgweather
    gucharmap
    gnome-settings-daemon
    tracker
    polkit
    wirelesstools
    linuxPackages.cpupower
  ];

  enableParallelBuilding = true;

  doCheck = true;

  configureFlags = [
    "--with-libpanel-applet-dir=${placeholder ''out''}/share/gnome-panel/applets"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Applets for use with the GNOME panel";
    homepage = https://wiki.gnome.org/Projects/GnomeApplets;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
