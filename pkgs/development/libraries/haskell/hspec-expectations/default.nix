{ cabal, hspec, HUnit, markdownUnlit, silently }:

cabal.mkDerivation (self: {
  pname = "hspec-expectations";
  version = "0.3.3";
  sha256 = "0sg7wkgr9qmwv0bki1q8wvl5jrlsvn0c7sd2qpqp3cccdhwj9c5k";
  buildDepends = [ HUnit ];
  testDepends = [ hspec HUnit markdownUnlit silently ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/sol/hspec-expectations#readme";
    description = "Catchy combinators for HUnit";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
