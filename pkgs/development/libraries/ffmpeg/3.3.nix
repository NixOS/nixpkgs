{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.1";
  sha256 = "0bwgm6z6k3khb91qh9xv15inykkfchpkm0lcdckkxhkacpyaf0mp";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
