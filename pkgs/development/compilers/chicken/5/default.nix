{ callPackage }:

(callPackage ../common {
  version = "5.4.0";
  hash = "sha256-PF1KphwRZ79tm/nq+JHadjC6n188Fb8JUVpwOb/N7F8=";
  binaryVersion = 11;

  # Disable two broken tests: "static link" and "linking tests"
  postPatch = ''
    sed -i tests/runtests.sh -e "/static link/,+4 { s/^/# / }"
    sed -i tests/runtests.sh -e "/linking tests/,+11 { s/^/# / }"
  '';

  depsFile = ./deps.toml;
  overridesFile = ./overrides.nix;

  # cond-expand shows up because read-egg.scm flattens conditional dependency
  # forms to their head.
  invalidDependencies = [
    "srfi-4"
    "cond-expand"
    "http-curl"
  ];
}).overrideScope
  (
    final: prev: {
      # egg2nix generates the hand-curated CHICKEN 4 egg set, but is itself a
      # CHICKEN 5 program.
      egg2nix = final.callPackage ./egg2nix.nix { };
    }
  )
