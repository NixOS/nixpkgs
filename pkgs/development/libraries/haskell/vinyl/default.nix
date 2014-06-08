{ cabal, doctest, lens }:

cabal.mkDerivation (self: {
  pname = "vinyl";
  version = "0.3";
  sha256 = "0wa7pdk5ds1zq0yy6lbzhpjglpnz56hg36iwma09b6jk2x71sf5r";
  testDepends = [ doctest lens ];
  meta = {
    description = "Extensible Records";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
