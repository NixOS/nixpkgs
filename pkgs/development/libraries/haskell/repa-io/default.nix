{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.2.2.3";
  sha256 = "1rzis7gp9dq06czqmnj9p7hpyfkdbirx2bldhg5mz3glmqf4xvw5";
  buildDepends = [ binary bmp repa vector ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
