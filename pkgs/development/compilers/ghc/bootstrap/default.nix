# GHC built from source, with no Haskell binary to start from.  Hugs (C) runs
# MicroHs, MicroHs compiles GHC 6.2.2's compiler proper, and that compiler
# then builds GHC 6.2.2's runtime and libraries and compiles itself until its
# output reaches a fixed point.
#
# The chain, its patches and the reasons for each step come from
# https://github.com/andreabedini/ghc-bootstrap.  The derivations here follow
# that repository's, with Nixpkgs' hugs and microhs in place of its own, and
# read the patches, shims and helper scripts from a pinned copy of it.
{
  lib,
  newScope,
  fetchFromGitHub,
  microhs,
}:

lib.makeScope newScope (self: {
  ghc-bootstrap-src = fetchFromGitHub {
    owner = "andreabedini";
    repo = "ghc-bootstrap";
    rev = "436cc10129a2119a9de1389bcdbdae02fb7ed7fb";
    hash = "sha256-F0y262lyEPmBN8Nt+6evb1SYO2ZQ+eIEndGrB2WwrRM=";
  };

  mhs = microhs;
  # MicroHs's runtime sources, which programs compiled to C are linked with
  mhsRuntime = "${microhs}/lib/mcabal/${microhs.haskellCompilerName}/packages/${microhs.haskellCompilerName}/data/src/runtime";
  inherit (microhs) cpphs;

  happy = self.callPackage ./happy.nix { };
  gmp = self.callPackage ./gmp.nix { };
  ghc622 = self.callPackage ./6.2.2 { };
})
