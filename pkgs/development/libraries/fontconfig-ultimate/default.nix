{ callPackage }:

{
  confd = callPackage ./confd.nix {};
  rendering = callPackage ./rendering.nix {};
}
