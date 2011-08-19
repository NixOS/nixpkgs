{ cabal, HList, mtl }:

cabal.mkDerivation (self: {
  pname = "AspectAG";
  version = "0.3.4";
  sha256 = "1icbmqygjp9xrsbc22g2y7pcvq193w5av7rk8pi2cbfgsimcl8gs";
  buildDepends = [ HList mtl ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/Center/AspectAG";
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
