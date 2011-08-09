{ cabal }:

cabal.mkDerivation (self: {
  pname = "uulib";
  version = "0.9.13";
  sha256 = "115fxvx5lqyjdwws6gkcixk1gi2p5gkyqinww7gbp54p4n0yy7n0";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Haskell Utrecht Tools Library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
