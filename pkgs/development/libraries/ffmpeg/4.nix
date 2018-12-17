{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1";
  sha256 = "19d16dhb4gx3akhbqd8844awx1axxli91bsjwsm4qp2a4i1zp15n";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
