{ cabal, deepseq, syb }:

cabal.mkDerivation (self: {
  pname = "symbol";
  version = "0.1.3";
  sha256 = "1kz4kzbv6bara31pv4vc75r6wvjln6md8gjlsxx8hf50ab8vb68j";
  buildDepends = [ deepseq syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "A 'Symbol' type for fast symbol comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
