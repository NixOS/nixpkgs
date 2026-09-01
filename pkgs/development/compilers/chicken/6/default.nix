{ callPackage }:

callPackage ../common {
  version = "6.0.0";
  hash = "sha256-koNVUrG2h60mc35Cm1q6NlEL9Cn4gW7A9tM2yMtB9EM=";
  binaryVersion = 12;

  depsFile = ./deps.toml;
  overridesFile = ./overrides.nix;

  # r7rs is part of the core in CHICKEN 6 and has no egg in the 6 channel;
  # cond-expand shows up because read-egg.scm flattens conditional dependency
  # forms to their head, and the only egg using one restricts it to CHICKEN 5.
  invalidDependencies = [
    "cond-expand"
    "r7rs"
  ];
}
