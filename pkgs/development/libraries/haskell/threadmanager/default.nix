{ cabal }:

cabal.mkDerivation (self: {
  pname = "threadmanager";
  version = "0.1.6";
  sha256 = "16q09kx3rfjaa3rvyfwrxpsnvw50r3q8pk1if6xm0v4ya3lbvibs";
  meta = {
    description = "(deprecated in favor of 'threads') Simple thread management";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
