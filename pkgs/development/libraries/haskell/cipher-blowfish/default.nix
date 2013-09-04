{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cipher-blowfish";
  version = "0.0.1";
  sha256 = "0bz8jd65idcalyzcbmgz16hr6y5mnw7mckk5yvrm9k19cr6mwq52";
  buildDepends = [ byteable cryptoCipherTypes securemem vector ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Blowfish cipher";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
