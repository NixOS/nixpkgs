{ cabal, chell, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "chell-quickcheck";
  version = "0.2.4";
  sha256 = "0ys6aks97y5h0n8n8dmwx8jrai4bjlnr7n69s259664y694054wd";
  buildDepends = [ chell QuickCheck random ];
  meta = {
    homepage = "https://john-millikin.com/software/chell/";
    description = "QuickCheck support for the Chell testing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
