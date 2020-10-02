{ stdenv
, fetchurl
, fetchpatch
, intltool
, autoreconfHook
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

stdenv.mkDerivation rec {
  pname = "gnome-applets";
  version = "3.37.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0l1mc9ymjg0bgk92a08zd85hx1vaqrzdj0dwzmna20rp51vf0l4a";
  };
  patches = [
    # Enable to configure gnome panel's modules dir. See
    # https://gitlab.gnome.org/GNOME/gnome-applets/-/merge_requests/65
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-applets/commit/c9724bd40e50c22880e1dc7f21ddb6b161d2691c.diff";
      sha256 = "1qd0li7jlyn33r8674g4fs08kf0q6na719vc4nccp55rhwy487b6";
    })
  ];

  nativeBuildInputs = [
    intltool
    itstool
    pkgconfig
    libxml2
    libxslt
    # Our patch changes configure.ac
    autoreconfHook
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
    # Don't try to install modules to gnome panel's directory, as it's read only
    "GNOME_PANEL_MODULES_DIR=${placeholder "out"}/share/gnome-panel/applets"
  ];

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
