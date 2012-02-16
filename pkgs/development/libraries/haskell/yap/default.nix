{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "yap";
  version = "0.2";
  sha256 = "14lq549jhgnf51pgy1jv31ik8qx71yl7d53w8dpq1f9mlsn1g16i";
  buildDepends = [ Cabal ];
  meta = {
    description = "yet another prelude - a simplistic refactoring with algebraic classes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
