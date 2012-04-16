{ cabal, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "repa";
  version = "3.1.1.1";
  sha256 = "0r78xd8caqpjvf1wxlv9mp13n5as8k98j76sni6wyrj2i55sx7ls";
  buildDepends = [ QuickCheck vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "High performance, regular, shape polymorphic parallel arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
