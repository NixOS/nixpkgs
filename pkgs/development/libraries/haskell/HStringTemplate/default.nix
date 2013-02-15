{ cabal, blazeBuilder, deepseq, filepath, mtl, parsec, syb, text
, time, utf8String, void
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.7.0";
  sha256 = "0xxxikgjw1dhx7kx3mjyvgh70m9avcd1kbp2bpig6gjwswk0mmai";
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
