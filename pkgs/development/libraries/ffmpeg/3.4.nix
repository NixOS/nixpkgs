{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = branch;
  branch = "3.4.7";
  sha256 = "0hj91gjps92f4w3yyqss89yrs6s75574hbj5gz9g5affd6294yhc";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
