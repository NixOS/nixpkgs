# https://phabricator.haskell.org/D4159 to fix non-determinism in
# cached abi-depends fields in package databases, modified to only
# contain hunks that exist in distribution tarballs.
{ fetchpatch, runCommand }: let
  base = fetchpatch rec { # Non-determinism in cached abi-depends fields
    # Originally https://phabricator-files.haskell.org/file/data/4pqrbo5b62sifktfbrls/PHID-FILE-4g4zjiqlfxmmlaos7lz7/D4159.diff
    url = "http://tarballs.nixos.org/sha256/${sha256}";
    name = "D4159.diff";
    sha256 = "0b8a08sisf1swmarm6nh9rgw7cpzi2rwdzvrd6ny49c7wk0f7x4b";
  };
in runCommand base.name {}
  "sed -n '/utils\\/ghc-pkg/,$p' ${base} >$out"
