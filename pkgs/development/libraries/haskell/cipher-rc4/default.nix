{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cipher-rc4";
  version = "0.1.3";
  sha256 = "1pdkm7m3v8c7wks7asvqixxjk9jixf78n489ckmw10p77wrqby78";
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
