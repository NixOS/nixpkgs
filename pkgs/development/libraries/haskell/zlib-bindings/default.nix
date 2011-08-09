{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.0.0";
  sha256 = "168sll6mrmcnvdmdx79izqxcrli1s7asp4qilhkqss8w0jlrv1ni";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
