{ cabal, comonad }:

cabal.mkDerivation (self: {
  pname = "comonads-fd";
  version = "4.0";
  sha256 = "19xpv0dsz7w3a1sq1gdxwzglfal45vj2s22zb12g9mpk5rp3hw1s";
  buildDepends = [ comonad ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/ekmett/comonads-fd/";
    description = "This package has been merged into comonad 4.0";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
