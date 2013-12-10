{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10.7";
  sha256 = "0mhsj27vynilpmwxgdpb3r383rksrqs9ix15zl2xbhc95a815pfl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
