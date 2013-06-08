{ cabal, comonad, distributive, groupoids, semigroupoids }:

cabal.mkDerivation (self: {
  pname = "semigroupoid-extras";
  version = "3.0.1";
  sha256 = "1b6ix9myjav1h4bbq3jxlan8sn2pjw8x0zhazv3anxfab5n2sxpd";
  buildDepends = [ comonad distributive groupoids semigroupoids ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoid-extras";
    description = "Semigroupoids requiring Haskell extensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
