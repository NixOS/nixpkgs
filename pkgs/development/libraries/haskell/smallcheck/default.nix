{ cabal, logict, mtl }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "1.0.2";
  sha256 = "09zlsvgbwgpjwkjhizbzzww2nvkyxvkf214yqxzfaa1cj9xzbbdi";
  buildDepends = [ logict mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
