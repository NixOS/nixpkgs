{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4.1";
  sha256 = "0b2aaxx8l7g3pvs4zd3mzig44cc73savrxzfm6w0lnaa2lh3wi7k";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
