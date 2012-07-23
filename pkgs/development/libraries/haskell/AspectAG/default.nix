{ cabal, HList, mtl }:

cabal.mkDerivation (self: {
  pname = "AspectAG";
  version = "0.3.5";
  sha256 = "1gqblgd0js2nliad1gryg8a3sibw5xsp577c8h3vhdfssf2bwggs";
  buildDepends = [ HList mtl ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/Center/AspectAG";
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
