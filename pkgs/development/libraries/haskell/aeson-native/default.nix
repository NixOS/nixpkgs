{ cabal, attoparsec, blazeBuilder, blazeTextualNative, deepseq
, hashable, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson-native";
  version = "0.3.3.1";
  sha256 = "15733f5ivymkbwvqgbd8scynl9adva3fnid4bzlr9l4sb3yvcz9p";
  buildDepends = [
    attoparsec blazeBuilder blazeTextualNative deepseq hashable mtl syb
    text time unorderedContainers vector
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
