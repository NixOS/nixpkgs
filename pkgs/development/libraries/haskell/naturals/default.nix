{ cabal }:

cabal.mkDerivation (self: {
  pname = "naturals";
  version = "0.2.0.2";
  sha256 = "1ay291833dcah411zc3r4qjilaw8x13ljlnb5z40d1s7784djm16";
  meta = {
    homepage = "frigidcode.com";
    description = "Constructors and related functions for natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
