{ cabal, doctest, lens, singletons }:

cabal.mkDerivation (self: {
  pname = "vinyl";
  version = "0.4.2";
  sha256 = "17vh5yv9dzw6zq1xw22k7mljpha0rcngbk5k0kynh7hyh6xy4zxz";
  testDepends = [ doctest lens singletons ];
  meta = {
    description = "Extensible Records";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
