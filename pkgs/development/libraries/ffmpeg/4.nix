{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1.3";
  sha256 = "0aka5pibjhpks1wrsvqpy98v8cbvyvnngwqhh4ajkg6pbdl7k9i9";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
