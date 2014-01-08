{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.9";
  sha256 = "0qxbibq6lj7gyw62crp774pv2a8cm83rllw5yjjsg372nk4m1is0";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
