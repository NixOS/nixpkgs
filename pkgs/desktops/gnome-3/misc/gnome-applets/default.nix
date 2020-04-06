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
, wirelesstools
, linuxPackages
, adwaita-icon-theme
, libgweather
, gucharmap
, tracker
, polkit
, gnome3
}:

let
  pname = "gnome-applets";
  version = "3.36.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "096n0ji478hfdrbi8illsyvdsgxznxfayr826pr9jdgzg1s0x9xs";
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

  configureFlags = [
    "--with-libpanel-applet-dir=${placeholder "out"}/share/gnome-panel/applets"
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
