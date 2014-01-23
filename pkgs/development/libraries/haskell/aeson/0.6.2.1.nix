{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, mtl
, QuickCheck, syb, testFramework, testFrameworkQuickcheck2, text
, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.6.2.1";
  sha256 = "00fa13qr38s4c0fwfvpks3x3sb21kh71cv1v0x2zqg0adnaydknb";
  buildDepends = [
    attoparsec blazeBuilder deepseq dlist hashable mtl syb text time
    unorderedContainers vector
  ];
  testDepends = [
    attoparsec QuickCheck testFramework testFrameworkQuickcheck2 text
    time unorderedContainers vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
