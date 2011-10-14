{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.4";
  sha256 = "0sa0a4hg0xp8l64dy8hnfkhvy2miv79b5550v8gkvrbqcci0qfay";
  buildDepends = [ StateVar transformers ];
  noHaddock = true;
  meta = {
    homepage = "http://patch-tag.com/r/felipe/hipmunk/home";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
