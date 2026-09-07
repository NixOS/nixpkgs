{ callPackage }:

{
  bashup-events32 = callPackage ./3.2.nix { };
  bashup-events44 = callPackage ./4.4.nix { };
}
