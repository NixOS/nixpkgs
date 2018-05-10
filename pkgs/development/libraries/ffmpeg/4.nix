{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.0";
  sha256 = "1f3k8nz5ag6szsfhlrz66qm8s1yxk1vphqvcfr4ps4690vckk2ii";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
