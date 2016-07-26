{ stdenv, callPackage }:
callPackage ./generic.nix (rec {
  version = "2.40.9";
  sha256 = "0fplymmqqr28y24vcnb01szn62pfbqhk8p1ngns54x9m6mflr5hk";
})

