{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.1.1.1";
  sha256 = "1r502gskbm36smd5nj0f53ildv9rkm3k79zmwdmrskg6z1n7jmfh";
  buildDepends = [ zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
