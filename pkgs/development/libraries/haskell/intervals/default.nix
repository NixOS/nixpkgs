{ cabal, distributive, doctest, filepath }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.7";
  sha256 = "00kwq57x72xi5kca7symb98nzs1j82r6bkgvr83aqpvq0ql9ka9d";
  buildDepends = [ distributive ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
