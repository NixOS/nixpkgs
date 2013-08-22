{ cabal }:

cabal.mkDerivation (self: {
  pname = "threadmanager";
  version = "0.1.7";
  sha256 = "17s26hlailbr8c9d3dv1pwiy81m3nzr3sw0v9y716rmhldf7k09f";
  meta = {
    description = "(deprecated in favor of 'threads') Simple thread management";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
