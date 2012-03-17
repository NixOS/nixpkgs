{ callPackage }:

{
  clutter = callPackage ./platform/clutter.nix { };

  libgnome_keyring = callPackage ./platform/libgnome-keyring.nix { };

  GConf = callPackage ./platform/GConf.nix { };

  gnome_user_docs = callPackage ./platform/gnome-user-docs.nix { };
}
