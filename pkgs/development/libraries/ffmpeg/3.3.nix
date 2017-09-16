{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.4";
  sha256 = "0zmczggi95fbsq9nz33mpln1y3p1gqniqc4x5smp871idhkykxay";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
