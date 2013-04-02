{ cabal, deepseq, QuickCheck, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.10.4.0";
  sha256 = "0inkcrl40j9kgcmmi0xkcszayqjd5yn7i9fyvv0ywfqwpl6lxf5n";
  buildDepends = [ deepseq text ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
