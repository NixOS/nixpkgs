{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.3";
  sha256 = "1wv868m24ds2hf2iwrv1hw1v0r82kjs2qhcp5b1p2jrdl26fhzd8";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
