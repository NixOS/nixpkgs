{ cabal, regexPosix }:

cabal.mkDerivation (self: {
  pname = "language-haskell-extract";
  version = "0.2.4";
  sha256 = "1nxcs7g8a1sp91bzpy4cj6s31k5pvc3gvig04cbrggv5cvjidnhl";
  buildDepends = [ regexPosix ];
  meta = {
    homepage = "http://github.com/finnsson/template-helper";
    description = "Module to automatically extract functions from the local code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
