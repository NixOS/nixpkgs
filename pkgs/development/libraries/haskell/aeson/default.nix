{ cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, hashable
, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.3.2.11";
  sha256 = "0cvavxb3bm5kz491wrx5az5scvddndw2rh45snhj1xn0flr1c2n7";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual deepseq hashable mtl syb text
    time unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/mailrank/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
