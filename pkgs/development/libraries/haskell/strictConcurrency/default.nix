{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "strict-concurrency";
  version = "0.2.4.1";
  sha256 = "0939212dd0cc3b9bd228dfbb233d9eccad22ca626752d9bad8026ceb0a5c1a89";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/strict-concurrency";
    description = "Strict concurrency abstractions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
