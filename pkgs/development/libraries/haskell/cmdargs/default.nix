{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.8";
  sha256 = "0yhjg6rck1aj8gq07i9dcfxyjffxlr4lxnir2brkyahpfx5iyw9k";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
