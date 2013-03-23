{ cabal, alex }:

cabal.mkDerivation (self: {
  pname = "bytestring-lexing";
  version = "0.4.3";
  sha256 = "0dynfrf8ym01v2dl57422h8r75kdlqh2qzqi9yc0f1bmbfqxap6r";
  buildTools = [ alex ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Parse and produce literals efficiently from strict or lazy bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
