{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, mtl
, QuickCheck, syb, testFramework, testFrameworkQuickcheck2, text
, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.6.2.0";
  sha256 = "1f7bzgwl9pm5a79gr3a8wxh7dyz4k2508d0bw4l0mbjgv6r7s4an";
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
