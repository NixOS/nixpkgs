{ cabal, distributive, doctest, filepath }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.4";
  sha256 = "0w33arfv1hd3a3l4rvn67nh5q6w05jj6hjlbjmbmrjyhwg35jnac";
  buildDepends = [ distributive ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
