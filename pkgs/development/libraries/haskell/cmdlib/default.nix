{ cabal, mtl, split, syb, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdlib";
  version = "0.3.4";
  sha256 = "1f8vb681xd2v7hv0s84x032yf8x2jlxc0j302irv20fkc1w1vbrr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl split syb transformers ];
  meta = {
    description = "a library for command line parsing & online help";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
