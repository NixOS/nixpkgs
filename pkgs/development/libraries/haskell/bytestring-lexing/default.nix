{ cabal, alex }:

cabal.mkDerivation (self: {
  pname = "bytestring-lexing";
  version = "0.4.0";
  sha256 = "1lww38rab9k8drndqkg306kiq6663i89sq6l1bvjv6cs13acc8wr";
  buildTools = [ alex ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Parse and produce literals efficiently from strict or lazy bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
