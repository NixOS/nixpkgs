{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3";
  sha256 = "1p3brx0qa3i3569zlmcmpbxf17q73nrmbx2vp39s8h77r53qdq11";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
