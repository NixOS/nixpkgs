{ cabal, chell, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "chell-quickcheck";
  version = "0.2.2";
  sha256 = "05qshv9vcl05khxsxyks2z7dqd8dqafjsg3awkkdhviviv5p2fp8";
  buildDepends = [ chell QuickCheck random ];
  meta = {
    homepage = "https://john-millikin.com/software/chell/";
    description = "QuickCheck support for the Chell testing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
