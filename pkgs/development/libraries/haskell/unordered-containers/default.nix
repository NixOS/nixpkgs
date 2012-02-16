{ cabal, Cabal, deepseq, hashable }:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.1.4.6";
  sha256 = "1azwxbrzlzaw54idp3z2xx1xlywzsf1r893blbz51nnwcj9v550d";
  buildDepends = [ Cabal deepseq hashable ];
  meta = {
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
