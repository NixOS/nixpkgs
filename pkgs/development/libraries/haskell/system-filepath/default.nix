{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.10";
  sha256 = "176g5jm1gd6lrkmhfz9qh5aqwfbpwyr30yknfcc49wl7jkfhisiq";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
