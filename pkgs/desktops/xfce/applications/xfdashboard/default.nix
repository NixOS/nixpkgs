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
  version = "0.7.7";
  rev-prefix = "";
  odd-unstable = false;

  sha256 = "0b9pl3k8wl7svwhb9knhvr86gjg2904n788l8cbczwy046ql7pyc";

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
