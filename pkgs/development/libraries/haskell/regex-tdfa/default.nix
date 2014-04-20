{ cabal, mtl, parsec, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-tdfa";
  version = "1.2.0";
  sha256 = "00gl9sx3hzd83lp38jlcj7wvzrda8kww7njwlm1way73m8aar0pw";
  buildDepends = [ mtl parsec regexBase ];
  meta = {
    homepage = "http://hackage.haskell.org/package/regex-tdfa";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
