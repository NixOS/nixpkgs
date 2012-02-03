{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "containers-deepseq";
  version = "0.1.0.1";
  sha256 = "0l9d7hj66fygpsbjw6wy4l11c9cw739lvkrypapwihav7jzva541";
  buildDepends = [ deepseq ];
  meta = {
    description = "Provide orphan NFData instances for containers as needed. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
