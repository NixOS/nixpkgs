{cabal, HList, mtl} :

cabal.mkDerivation (self : {
  pname = "AspectAG";
  version = "0.3.3";
  sha256 = "06vmdg72f7v11603a0y6f5wq5lydi5inx1d98nwgpp4vj8y138j1";
  propagatedBuildInputs = [ HList mtl ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/Center/AspectAG";
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
