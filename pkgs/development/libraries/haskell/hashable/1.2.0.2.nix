{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.2.0.2";
  sha256 = "1l827sh7v2jls2gcbxgbvz5hacwi43bcrxwmd3wp92hfwy1yza65";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
