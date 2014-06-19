{ cabal, aeson, indexed, indexedFree, lens, text }:

cabal.mkDerivation (self: {
  pname = "json-assertions";
  version = "1.0.3";
  sha256 = "1iklsgzfxgiizqn90r9wfzfaz84fj8by4arppp139w6ybzh3b0r8";
  buildDepends = [ aeson indexed indexedFree lens text ];
  meta = {
    homepage = "http://github.com/ocharles/json-assertions.git";
    description = "Test that your (Aeson) JSON encoding matches your expectations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
