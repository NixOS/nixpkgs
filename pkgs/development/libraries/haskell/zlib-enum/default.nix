{ cabal, enumerator, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-enum";
  version = "0.2.1";
  sha256 = "0cnx7sbgj6s0gvq6pcqyi3xahx7x3bj47ap10z89qfbk0906rkq8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ enumerator transformers zlibBindings ];
  meta = {
    homepage = "http://github.com/maltem/zlib-enum";
    description = "Enumerator interface for zlib compression";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
