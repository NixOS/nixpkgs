{ cabal, filepath, terminfo, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.7.1.2";
  sha256 = "178hzal5gqw3rmgijv9ph9xa6d4sld279z4a8cjyx3hv4azciwr4";
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
