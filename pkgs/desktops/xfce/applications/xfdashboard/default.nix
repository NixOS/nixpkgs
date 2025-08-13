{
  lib,
  mkXfceDerivation,
  clutter,
  gettext,
  libXcomposite,
  libXinerama,
  libXdamage,
  libX11,
  libwnck,
  libxfce4ui,
  libxfce4util,
  garcon,
  xfconf,
  gtk3,
  glib,
  dbus-glib,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfdashboard";
  version = "1.0.0-unstable-2025-07-18";
  # Fix build with gettext 0.25
  rev = "93255940950ef5bc89cab729c8b977a706f98e0c";
  rev-prefix = "";

  sha256 = "sha256-Qv0ASuJF0FzPoeLx2D6/kXkxnOJV7mdAFD6PCk+CMac=";

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    clutter
    dbus-glib
    garcon
    glib
    gtk3
    libX11
    libXcomposite
    libXdamage
    libXinerama
    libwnck
    libxfce4ui
    libxfce4util
    xfconf
  ];

  meta = with lib; {
    description = "Gnome shell like dashboard";
    teams = [ teams.xfce ];
  };
}
