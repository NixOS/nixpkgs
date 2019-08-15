{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.2";
  sha256 = "1f3glany3p2j832a9wia5vj8ds9xpm0xxlyia91y17hy85gxwsrh";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
