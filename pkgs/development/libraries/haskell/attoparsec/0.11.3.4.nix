{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.11.3.4";
  sha256 = "1zahmkb0n7jz0di35x3r8s0xnfg1awqybh2x2zicxbwazl4f53hi";
  buildDepends = [ deepseq scientific text ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
