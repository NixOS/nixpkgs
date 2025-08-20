{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.2";
    hash = "sha256-zClgj7m0JK2PNWi/1kA2L+HklzaHoT09KwnVt7Rm4ks=";
  }
  // args
)
