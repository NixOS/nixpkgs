{ cabal, Cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.6";
  sha256 = "0p8lf10b5zn2gw5klpjc397q892cydvnl677srj9rk3lhmsm5jjl";
  buildDepends = [ Cabal deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
