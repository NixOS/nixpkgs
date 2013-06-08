{ cabal, blazeBuilder, deepseq, filepath, mtl, parsec, syb, text
, time, utf8String, void
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.7.1";
  sha256 = "0hqc1496xazihlww8j90m1cwzj7cihqbfjdly9s8kjf8d5my64ld";
  buildDepends = [
    blazeBuilder deepseq filepath mtl parsec syb text time utf8String
    void
  ];
  meta = {
    description = "StringTemplate implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
