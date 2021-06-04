{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2021-05-29";
  rev = "839fb5bd72341d8e67b6cfc2053e2acffdb75567";
  isStable = false;
  sha256 = "1gyzq4n0fwah0245wazv4c43q9in1mwbk3dhh6cb1ijnjcxp2bb6";
}
