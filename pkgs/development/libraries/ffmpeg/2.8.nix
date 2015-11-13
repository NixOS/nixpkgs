{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.1";
  branch = "2.8";
  sha256 = "1qk6g2h993i0wgs9d2p3ahdc5bqr03mp74bk6r1zj6pfinr5mvg2";
})
