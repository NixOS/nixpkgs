{
  mkDerivation,
  base,
  Cabal,
  containers,
  lens,
  lib,
  process,
}:
mkDerivation {
  pname = "cabal-pkg-config-version-hook";
  version = "0.1.1.0";
  sha256 = "18l87dcq2854vqchg21bvv85sdm4126nbk8sj9ilr5819qslk26f";
  libraryHaskellDepends = [
    base
    Cabal
    containers
    lens
    process
  ];
  homepage = "https://github.com/hercules-ci/hercules-ci-agent/tree/master/cabal-pkg-config-version-hook#readme";
  description = "Make Cabal aware of pkg-config package versions";
  license = lib.licensesSpdx."BSD-3-Clause";
}
