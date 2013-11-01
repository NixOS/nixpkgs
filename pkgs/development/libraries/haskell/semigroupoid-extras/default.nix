{ cabal, semigroupoids }:

cabal.mkDerivation (self: {
  pname = "semigroupoid-extras";
  version = "4.0";
  sha256 = "07aa7z4nywcrp9msq83b1pcmryl25yxha89sn5vwlgq40cibcm3g";
  buildDepends = [ semigroupoids ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoid-extras";
    description = "This package has been absorbed into semigroupoids 4.0";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
