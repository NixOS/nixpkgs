{ cabal, text, transformers }:

cabal.mkDerivation (self: {
  pname = "enumerator";
  version = "0.4.20";
  sha256 = "02a75dggj295zkhgjry5cb43s6y6ydpjb5w6vgl7kd9b6ma11qik";
  buildDepends = [ text transformers ];
  meta = {
    homepage = "https://john-millikin.com/software/enumerator/";
    description = "Reliable, high-performance processing with left-fold enumerators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
