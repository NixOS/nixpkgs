{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4.3";
  sha256 = "0s2p2bcrywlya4wjlyzi1382vngkiijjvjr6ms64xww5jplwmhmk";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
