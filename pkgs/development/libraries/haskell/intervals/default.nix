{ cabal, distributive, doctest, filepath }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.4.2";
  sha256 = "08l7q22rlhyigls1qksf7lnb7g1yrkmdh9clq68xxaf6wzm26aaz";
  buildDepends = [ distributive ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
