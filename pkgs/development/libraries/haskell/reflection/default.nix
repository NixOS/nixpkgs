{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.2.0.1";
  sha256 = "17pzw45yr13nq9y9nb3siypj5amkixy82xm8bpy0nzs1cdfyawx6";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
