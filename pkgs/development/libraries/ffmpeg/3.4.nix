{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4";
  sha256 = "0pn8g3ab937ahslqd41crk0g4j4fh7kwimsrlfc0rl0pc3z132ax";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
