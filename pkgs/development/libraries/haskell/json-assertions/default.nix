{ cabal, aeson, indexed, indexedFree, lens, text }:

cabal.mkDerivation (self: {
  pname = "json-assertions";
  version = "1.0.2";
  sha256 = "0ppj1xxbi0yrmv6vkmwkz91vvwzjd0ixj60432liwmd6h13apky0";
  buildDepends = [ aeson indexed indexedFree lens text ];
  meta = {
    homepage = "http://github.com/ocharles/json-assertions.git";
    description = "Test that your (Aeson) JSON encoding matches your expectations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
