args@{ callPackage, ... }:

callPackage (import ./generic.nix {
  version = "1.1.5";
  sha256 = "1ifpcqw5mj2dwk23lhc2vpb47mg3j573v5z4zp8dkczpz7wg5jxq";
}) args
