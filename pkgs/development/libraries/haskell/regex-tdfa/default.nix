{ cabal, Cabal, mtl, parsec, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-tdfa";
  version = "1.1.8";
  sha256 = "1m75xh5bwmmgg5f757dc126kv47yfqqnz9fzj1hc80p6jpzs573x";
  buildDepends = [ Cabal mtl parsec regexBase ];
  meta = {
    homepage = "http://hackage.haskell.org/package/regex-tdfa";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
