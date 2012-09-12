{ cabal, HUnit }:

cabal.mkDerivation (self: {
  pname = "hspec-expectations";
  version = "0.3.0.2";
  sha256 = "1jwwi4pbv0pc88vdg5y0ljjq41sha4v4y5qaxi6qms7rl6cp4qkr";
  buildDepends = [ HUnit ];
  meta = {
    homepage = "https://github.com/sol/hspec-expectations#readme";
    description = "Catchy combinators for HUnit";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
