{ cabal, base64Bytestring, blazeMarkup, blazeSvg, colour
, diagramsCore, diagramsLib, filepath, hashable, JuicyPixels, lens
, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.1";
  sha256 = "0b34rh35pay4x8dg0i06xvr3d865hbxzj2x77jly9l1j7sa1qaj1";
  buildDepends = [
    base64Bytestring blazeMarkup blazeSvg colour diagramsCore
    diagramsLib filepath hashable JuicyPixels lens monoidExtras mtl
    split time vectorSpace
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "SVG backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
