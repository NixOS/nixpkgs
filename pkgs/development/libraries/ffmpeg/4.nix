{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1.1";
  sha256 = "0n5hz98gcyznj8lnqma6c9004vhcdzv67a4angnd1k6ai8xhxd0c";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
