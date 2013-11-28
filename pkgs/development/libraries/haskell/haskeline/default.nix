{ cabal, filepath, terminfo, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.7.1.1";
  sha256 = "1xwbjrak0jicbckk609sqwdlizpkn5zab0kqzrcw9swg1fxpwx5m";
  buildDepends = [ filepath terminfo transformers utf8String ];
  configureFlags = "-fterminfo";
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
