{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cipher-rc4";
  version = "0.1.4";
  sha256 = "0k9qf0cn5yxc4qlqikcm5yyrnkkvr6g3v7306cp8iwz7r4dp6zn6";
  buildDepends = [ byteable cryptoCipherTypes ];
  testDepends = [
    cryptoCipherTests cryptoCipherTypes QuickCheck testFramework
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-rc4";
    description = "Fast RC4 cipher implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
