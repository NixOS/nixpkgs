{ cabal, distributive, doctest, filepath }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.4.1";
  sha256 = "09pgy400r47lsa9w5g5dxydshw7lv9i4yv65ld1arssx3n59wyvl";
  buildDepends = [ distributive ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
