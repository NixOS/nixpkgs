{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.5";
  branch = "2.8";
  sha256 = "0nk1j3i7qc1k3dygpq74pxq382vqg9kaf2hxl9jfw8rkad8rjv9v";
})
