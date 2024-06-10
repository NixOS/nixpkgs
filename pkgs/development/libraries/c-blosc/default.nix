{ callPackage }: {
  c-blosc = callPackage ./1.nix {};
  c-blosc2 = callPackage ./2.nix {};
}
