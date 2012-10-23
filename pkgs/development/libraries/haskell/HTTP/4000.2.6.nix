{ cabal, mtl, network, parsec }:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.6";
  sha256 = "0rycwrn9cq9mrsgxkbx373zjvmzg4hd8hzclya6ipd3jda1w5r92";
  buildDepends = [ mtl network parsec ];
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
