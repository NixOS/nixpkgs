{ callPackage }:

{
  clutter = callPackage ./platform/clutter.nix { };

  cogl = callPackage ../../development/libraries/cogl { };

  # Ensure that we use dbus-glib built with gtkLibs3x.glib
  dbus_glib = callPackage ../../development/libraries/dbus-glib { };

  glib_networking = callPackage ./platform/glib-networking.nix { };

  libgnome_keyring = callPackage ./platform/libgnome-keyring.nix { };

  libsoup = callPackage ./platform/libsoup.nix { };

  gsettings_desktop_schemas = callPackage ./platform/gsettings-desktop-schemas.nix {};

  GConf = callPackage ./platform/GConf.nix { };

  gnome_user_docs = callPackage ./platform/gnome-user-docs.nix { };
}
