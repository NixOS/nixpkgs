{ cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, hashable
, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.3.2.12";
  sha256 = "12dq79bd8kvl4hc493c7ff9k9xdpibnnnfgpvpxh4ljnqcqr4hcy";
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
