{ cabal, cairo, colour, dataAccessor, dataAccessorTemplate, mtl
, time
}:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "0.17";
  sha256 = "1ip1a61ryypwfzj6dc6n6pl92rflf7lqf1760ppjyg05q5pn6qxg";
  buildDepends = [
    cairo colour dataAccessor dataAccessorTemplate mtl time
  ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "A library for generating 2D Charts and Plots";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
