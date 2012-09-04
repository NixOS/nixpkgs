{ cabal, filepath, terminfo, transformers }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.7.0.2";
  sha256 = "0mmflw8mslvif8w1app4zwrlpynpfvzqdb9srs6bgicawwgkb2r0";
  buildDepends = [ filepath terminfo transformers ];
  configureFlags = "-fterminfo";
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
