{ cabal, text, transformers }:

cabal.mkDerivation (self: {
  pname = "enumerator";
  version = "0.4.16";
  sha256 = "16556x3km4si7gvprf7xmsiqw1ygjwavhbgh32fmzf7709bpqnhs";
  buildDepends = [ text transformers ];
  meta = {
    homepage = "https://john-millikin.com/software/enumerator/";
    description = "Reliable, high-performance processing with left-fold enumerators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
