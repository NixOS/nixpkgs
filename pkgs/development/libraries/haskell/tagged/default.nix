{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.4.5";
  sha256 = "1ipj7ff2ya3r3w39clcrxs766hm568lj2kb2kd3npg87jj05wgv0";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
