{ cabal, aeson, indexed, indexedFree, lens, text }:

cabal.mkDerivation (self: {
  pname = "json-assertions";
  version = "1.0.1";
  sha256 = "0rpj300knyk602wqkqipmy54xv3pn20cd06sa8irkf2wz0xribzm";
  buildDepends = [ aeson indexed indexedFree lens text ];
  meta = {
    homepage = "http://github.com/ocharles/json-assertions.git";
    description = "Test that your (Aeson) JSON encoding matches your expectations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
