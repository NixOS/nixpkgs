{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.8";
  sha256 = "15x0yxakqqrdqvghr0l4pzvy5a68xxdv1c75d3qwx604665j3xkw";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
