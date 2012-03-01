{ cabal, mtl, text, time }:

cabal.mkDerivation (self: {
  pname = "convertible";
  version = "1.0.11.1";
  sha256 = "1r50a2rpfsx0s7dv8ww5xck33b1mhy73gfilffrbqd4hxjgnxlj6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl text time ];
  meta = {
    homepage = "http://hackage.haskell.org/cgi-bin/hackage-scripts/package/convertible";
    description = "Typeclasses and instances for converting between types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
