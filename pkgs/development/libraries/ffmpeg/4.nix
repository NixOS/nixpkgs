{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.0.3";
  sha256 = "0v40nygrv79inyvzcnv9zi75jya63n033j4gpm2r3hwnma40hr39";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
