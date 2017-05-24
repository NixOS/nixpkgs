{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.1";
  sha256 = "0c37bdqwmaziikr2d5pqp7504ail6i7a1mfcmc06mdpwfxxwvcpw";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
