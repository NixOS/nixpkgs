{ cabal, hspec, HUnit, markdownUnlit, silently }:

cabal.mkDerivation (self: {
  pname = "hspec-expectations";
  version = "0.5.0.1";
  sha256 = "0r1yy94q30gp3wyif7qfa22gn3g2lrszwygsy4wknc396fab7mvj";
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
