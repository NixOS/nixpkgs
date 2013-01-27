{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.1.6";
  sha256 = "1ihyx1a8pk1czam0qm1znl851dn4y6jip6s30girgghrvvxmblkw";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
