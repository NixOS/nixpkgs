{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-base";
  version = "0.4.0.1";
  sha256 = "0avnnxbxh59xgxzb8vldysrbw37sim9iaiiscgjhdlscxy6yasbb";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/mvv/transformers-base";
    description = "Lift computations from the bottom of a transformer stack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
