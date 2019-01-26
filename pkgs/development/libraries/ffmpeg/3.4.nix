{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4.5";
  sha256 = "0cbzysj9pskxh1kfdwmq2848fn6gi4pvh5y3insv10pdhpcjp8a3";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
