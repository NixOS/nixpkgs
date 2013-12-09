{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10.6";
  sha256 = "1ckzznza8nqidwq7vd6jlxkjgb7xd4rvqi7gm8ca9laj0cvwkclw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath transformers ];
  patchPhase = "touch cmdargs.cabal";
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
