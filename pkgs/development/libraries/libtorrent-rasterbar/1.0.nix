{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.0.11";
  sha256 = "17p34d3n29q04pvz975gfl1fyj3sg9cl5l6j673xqfq3fpyis58i";
})
