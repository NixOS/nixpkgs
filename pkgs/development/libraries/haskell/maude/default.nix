{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "maude";
  version = "0.3.0";
  sha256 = "1z9bk4fzkbfiqqx4mv4cdlckchvcli2gcp40d04ravvj7x6yaghg";
  buildDepends = [ parsec text ];
  meta = {
    homepage = "https://github.com/davidlazar/maude-hs";
    description = "An interface to the Maude rewriting system";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
