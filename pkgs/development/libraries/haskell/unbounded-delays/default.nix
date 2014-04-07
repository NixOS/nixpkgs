{ cabal }:

cabal.mkDerivation (self: {
  pname = "unbounded-delays";
  version = "0.1.0.7";
  sha256 = "1nv50i90hgvcl51w7s8x1c1ylpzyrbvs2mz5zfn68lr1ix2lk879";
  meta = {
    homepage = "https://github.com/basvandijk/unbounded-delays";
    description = "Unbounded thread delays and timeouts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
