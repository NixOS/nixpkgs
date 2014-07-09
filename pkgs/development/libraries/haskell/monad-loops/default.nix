{ cabal }:

cabal.mkDerivation (self: {
  pname = "monad-loops";
  version = "0.4.2.1";
  sha256 = "1dprwndc0bxzpmrkj1xb9kzjrg3i06zsg43yaabn5x5gcaj8is56";
  meta = {
    homepage = "https://github.com/mokus0/monad-loops";
    description = "Monadic loops";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
