{ cabal, filepath, terminfo, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.7.1.3";
  sha256 = "1bwyfn7y9mi18g7zxz8wxjkld51azlfbxypxbiqdinpm2fdl63mi";
  buildDepends = [ filepath terminfo transformers utf8String ];
  configureFlags = "-fterminfo";
  jailbreak = true;
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
