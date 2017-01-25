{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "4.6.0.182";
  sha256 = "1sajwl7fqhkcmh697qqjj4z6amzkay7xf7npsvpm10gm071s5qi6";
})
