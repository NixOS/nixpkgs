{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (rec {
  version = branch;
  branch = "3.4.8";
  sha256 = "1d0r4yja2dkkyhdwx1migq46gsrcbajiv66263a5sq5bfr9dqkch";
  darwinFrameworks = [ Cocoa CoreMedia ];
  knownVulnerabilities = [
    "CVE-2021-30123"
  ];
} // args)
