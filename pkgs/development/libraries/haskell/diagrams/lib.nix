{ cabal, active, colour, dataDefault, diagramsCore, monoidExtras
, newtype, NumInstances, semigroups, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "0.6.0.2";
  sha256 = "0jxpbggwgbjnl2yx7y0zcjs2fls7y1wm33wllq5j9snkiz1n81hb";
  buildDepends = [
    active colour dataDefault diagramsCore monoidExtras newtype
    NumInstances semigroups vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
