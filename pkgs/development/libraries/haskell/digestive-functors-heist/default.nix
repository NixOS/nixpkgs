{ cabal, digestiveFunctors, heist, text, xmlhtml }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.5.1.0";
  sha256 = "1rycf6y1c0car2m71iia929si5iqpc2rdyyxzp326q0rgj94whpk";
  buildDepends = [ digestiveFunctors heist text xmlhtml ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Heist frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
