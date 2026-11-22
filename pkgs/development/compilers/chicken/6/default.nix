{ callPackage }:

callPackage ../common {
  version = "6.1.0";
  hash = "sha256-xq7ppTdBAroxjgz65i3tXhglNGV3E3lS1/sVswlNSdg=";
  binaryVersion = 12;
  attrPath = "chickenPackages_6";

  depsFile = ./deps.toml;
  overridesFile = ./overrides.nix;

  # r7rs and srfi-4 are part of the core in CHICKEN 6, which maps both to
  # nothing in setup.defaults, and neither has an egg in the 6 channel;
  # cond-expand shows up because read-egg.scm flattens conditional dependency
  # forms to their head, and the only egg using one restricts it to CHICKEN 5.
  invalidDependencies = [
    "cond-expand"
    "r7rs"
    "srfi-4"
  ];
}
