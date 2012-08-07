{ cabal, digestiveFunctors, heist, text, xmlhtml }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.5.0.0";
  sha256 = "1cqzpnr53mailnmjgkbqk4f4hrjd84h6682mr8x7qg5v27zvcdbn";
  buildDepends = [ digestiveFunctors heist text xmlhtml ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Heist frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
