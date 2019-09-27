{ mkXfceDerivation, python3, exo, gtk3, libxfce4ui, dbus-glib, libxklavier, gobject-introspection, xorg, xfconf, garcon, libwnck3, xrandr, pam, systemd }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screensaver";
  version = "0.1.8";

  sha256 = "09asaha1d65965abxmxhrjb0mmz5ig0c2642lcb09kn22jsg7iw5";

  prePatch = ''
    sed -i "s@^DBUS_SESSION_SERVICE_DIR=.*@DBUS_SESSION_SERVICE_DIR=$out/share/dbus-1/services@" configure.ac
  '';

  buildInputs = [ 
    (python3.withPackages(ps: [ps.pygobject3])) gobject-introspection
    exo gtk3 dbus-glib libxklavier libxfce4ui xfconf garcon xorg.libXScrnSaver libwnck3 xrandr
    # optional
    pam systemd
  ];
}
