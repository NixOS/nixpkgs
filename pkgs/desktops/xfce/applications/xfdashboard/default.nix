{ mkXfceDerivation
, clutter
, libXcomposite
, libXinerama
, libXdamage
, libX11
, libwnck3
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
  version = "0.7.5";
  rev = "0.7.5";

  sha256 = "0d0kg90h3li41bs75z3xldljsglkz220pba39c54qznnzb8v8a2i";

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
    libwnck3
    libxfce4ui
    libxfce4util
    xfconf
  ];

  meta = {
    description = "Gnome shell like dashboard";
  };
}
