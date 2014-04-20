{ cabal }:

cabal.mkDerivation (self: {
  pname = "setenv";
  version = "0.1.1.1";
  sha256 = "0azkvsvk9i1979rn45zryqyirvjhj9b32nnz1m30aasbs2q8f393";
  doCheck = false;
  meta = {
    description = "A cross-platform library for setting environment variables";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
