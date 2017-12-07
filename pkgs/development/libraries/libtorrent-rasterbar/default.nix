{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.1.4";
  sha256 = "1rrp4b7zfz0fnjvax2r9r5rrh6z1s4xqb9dx20gzr4gs8x5v5jws";
})
