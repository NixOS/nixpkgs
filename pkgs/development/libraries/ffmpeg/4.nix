{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.0.2";
  sha256 = "0mnh41j3kzi3x3clai1yhqasr1kc8zvd5cz0283pxhs2bxrm2v1l";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
