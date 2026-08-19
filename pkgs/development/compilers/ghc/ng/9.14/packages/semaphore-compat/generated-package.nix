{ mkDerivation, base, exceptions, fetchzip, lib, unix }:
mkDerivation {
  pname = "semaphore-compat";
  version = "1.0.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/semaphore-compat-1.0.0/semaphore-compat-1.0.0.tar.gz";
    sha256 = "1m0a14ymd26kp20xnkggwadjpa7hwqnws5ssgrpb4ly44zpf7mr6";
  };
  libraryHaskellDepends = [ base exceptions unix ];
  homepage = "https://gitlab.haskell.org/ghc/semaphore-compat";
  description = "Cross-platform abstraction for system semaphores";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
