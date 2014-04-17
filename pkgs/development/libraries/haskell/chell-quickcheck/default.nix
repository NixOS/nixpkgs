{ cabal, chell, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "chell-quickcheck";
  version = "0.2.3";
  sha256 = "15j1wzhfyr9v8hy9d5lnr6jkrfr1zfb7dwgiy3ni90mvpf8x54yc";
  buildDepends = [ chell QuickCheck random ];
  meta = {
    homepage = "https://john-millikin.com/software/chell/";
    description = "QuickCheck support for the Chell testing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
