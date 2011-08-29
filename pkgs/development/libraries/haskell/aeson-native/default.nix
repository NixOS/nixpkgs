{ cabal, attoparsec, blazeBuilder, blazeTextualNative, deepseq
, hashable, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson-native";
  version = "0.3.3";
  sha256 = "1ckf0fqx0mdw7467kjk3q48fb4q5w6336i8fxk6j0wfk17xjfs8l";
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
