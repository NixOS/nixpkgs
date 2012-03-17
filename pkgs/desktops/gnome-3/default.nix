{ callPackage }:

{
  clutter = callPackage ./platform/clutter.nix { };

  gnome_user_docs = callPackage ./platform/gnome-user-docs.nix { };
}
