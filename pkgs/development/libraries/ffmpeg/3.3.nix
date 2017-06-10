{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.2";
  sha256 = "0slf12dxk6wq1ns09kqqqrzwylxcy0isvc3niyxig45gq3ah0s91";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
