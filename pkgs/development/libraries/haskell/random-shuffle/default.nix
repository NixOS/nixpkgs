{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "random-shuffle";
  version = "0.0.2";
  sha256 = "1csq0ffsqbbv6ymf707nzfb7c9bmykwk9bcgj21mxmh6khlqn9jp";
  buildDepends = [ random ];
  meta = {
    description = "Random shuffle implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
