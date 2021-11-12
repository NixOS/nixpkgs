{ mkXfceDerivation
, clutter
, libXcomposite
, libXinerama
, libXdamage
, libX11
, libwnck
, libxfce4ui
, libxfce4util
, garcon
, xfconf
, gtk3
, glib
, dbus-glib
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfdashboard";
  version = "0.9.5";
  rev-prefix = "";
  odd-unstable = false;

  sha256 = "sha256-nb1zY78MUjEOJF59MYIOY1rxo3JFmzH9yTJVUGsOwOA=";

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

  meta = {
    description = "Gnome shell like dashboard";
  };
}
