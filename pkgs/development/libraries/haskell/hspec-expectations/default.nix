{ cabal, hspec, HUnit, markdownUnlit, silently }:

cabal.mkDerivation (self: {
  pname = "hspec-expectations";
  version = "0.3.0.3";
  sha256 = "1ppcbfmcgrd1lwswa293fxwny6khhg4blygfbcsawrvgc5ji0q74";
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
