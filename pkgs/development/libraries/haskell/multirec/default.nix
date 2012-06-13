{ cabal }:

cabal.mkDerivation (self: {
  pname = "multirec";
  version = "0.7.2";
  sha256 = "1f715h27x8gz73d2irgl1gw74zd5lyda80nzk9xxwihqqkzvbhsm";
  noHaddock = true;
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic programming for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
