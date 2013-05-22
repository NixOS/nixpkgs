{ cabal, HList, mtl }:

cabal.mkDerivation (self: {
  pname = "AspectAG";
  version = "0.3.6.1";
  sha256 = "01pglvf38v5ii2w03kdlgngxbb3ih0j5bsilv5qwc9vrh2iwirhf";
  buildDepends = [ HList mtl ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/Center/AspectAG";
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
