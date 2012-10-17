{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.5.0.3";
  sha256 = "176wpnwg4zpfwphl0ifb3zdm0dhw5xyd3vr81rc98s4db5y9csl0";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
