{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.5";
  sha256 = "02h6y5sadqmci2ssalaxg65wa69ldscj05311zym8zijibzlqhqv";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
