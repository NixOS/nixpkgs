{ cabal, HList, mtl }:

cabal.mkDerivation (self: {
  pname = "AspectAG";
  version = "0.3.4.1";
  sha256 = "12iaf27crynwnnd7qm1zvvaj6zw6i6c05mb4dsq55dnhph2l356g";
  buildDepends = [ HList mtl ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/Center/AspectAG";
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
