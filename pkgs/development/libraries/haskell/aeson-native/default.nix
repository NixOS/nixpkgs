{ cabal, attoparsec, blazeBuilder, blazeTextualNative, deepseq
, hashable, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson-native";
  version = "0.3.3.2";
  sha256 = "1s5i88r8sdd7ayrpjw6f18273k6r0igk0sswb503hzvjagzmzffh";
  buildDepends = [
    attoparsec blazeBuilder blazeTextualNative deepseq hashable mtl syb
    text time unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/mailrank/aeson";
    description = "Fast JSON parsing and encoding (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
