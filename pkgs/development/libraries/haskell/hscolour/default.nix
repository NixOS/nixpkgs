{ cabal }:

cabal.mkDerivation (self: {
  pname = "hscolour";
  version = "1.20.2";
  sha256 = "0jl2m2bpsqg2hnf9mmwwrpa7af8wqwaajfp2h3nnnmy5qks10ad5";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://code.haskell.org/~malcolm/hscolour/";
    description = "Colourise Haskell code";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
