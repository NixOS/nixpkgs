{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.4";
  sha256 = "0i6yb3fa9wizyaz8x9b7yzkw9jf7zahdrkr2y0iw7igdxqn4n0k7";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
