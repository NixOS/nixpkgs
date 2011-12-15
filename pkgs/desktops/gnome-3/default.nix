{ callPackage }:

{
  # Ensure that we use dbus-glib built with gtkLibs3x.glib
  dbus_glib = callPackage ../../development/libraries/dbus-glib { };

  GConf = callPackage ./platform/GConf.nix { };
}
