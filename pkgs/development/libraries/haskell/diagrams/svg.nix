{ cabal, blazeMarkup, blazeSvg, colour, diagramsCore, diagramsLib
, filepath, hashable, lens, monoidExtras, mtl, split, time
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.0.1.1";
  sha256 = "0wjk2f7xh7ihkvdri669mw25bdwszzx03np32fy66k56x7adgxzc";
  buildDepends = [
    blazeMarkup blazeSvg colour diagramsCore diagramsLib filepath
    hashable lens monoidExtras mtl split time vectorSpace
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "SVG backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
