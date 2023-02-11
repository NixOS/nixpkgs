{ lib
, mkXfceDerivation
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
  version = "1.0.0";
  rev-prefix = "";

  sha256 = "sha256-iC41I0u9id9irUNyjuvRRzSldF3dzRYkaxb/fgptnq4=";

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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
