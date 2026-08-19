{ mkDerivation, base, criterion, deepseq, fetchzip, lib, QuickCheck
, random, tasty, tasty-hunit, tasty-quickcheck, template-haskell
}:
mkDerivation {
  pname = "time";
  version = "1.15";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/time-1.15/time-1.15.tar.gz";
    sha256 = "1byn4rs7fhq2j20d91m3cbsmi4zhm8wqc0fvh96vnmg3ir37i8vx";
  };
  libraryHaskellDepends = [ base deepseq template-haskell ];
  testHaskellDepends = [
    base deepseq QuickCheck random tasty tasty-hunit tasty-quickcheck
    template-haskell
  ];
  benchmarkHaskellDepends = [ base criterion deepseq ];
  homepage = "https://github.com/haskell/time";
  description = "A time library";
  license = lib.meta.getLicenseFromSpdxId "BSD-2-Clause";
}
