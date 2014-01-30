{ cabal }:

cabal.mkDerivation (self: {
  pname = "mime";
  version = "0.3.4";
  sha256 = "1klvy32idy6v029p5a6g93r79ac5cycnrx5c8z9bgvplbplpfjwy";
  meta = {
    homepage = "https://github.com/GaloisInc/mime";
    description = "Working with MIME types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
