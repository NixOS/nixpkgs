{ cabal, dependentSum }:

cabal.mkDerivation (self: {
  pname = "dependent-map";
  version = "0.1.1.1";
  sha256 = "1p5a5qahw7i6cvb0g0g1bv9gzy6jlxr5vb3hp8gahm210zw8g990";
  buildDepends = [ dependentSum ];
  meta = {
    homepage = "https://github.com/mokus0/dependent-map";
    description = "Dependent finite maps (partial dependent products)";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
