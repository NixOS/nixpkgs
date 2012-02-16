{ cabal, Cabal, haskellSrcExts, regexPosix }:

cabal.mkDerivation (self: {
  pname = "language-haskell-extract";
  version = "0.2.1";
  sha256 = "0lmg16g3z8cx0vb037bk4j2nr3qvybfcqfsr8l6jk57b2nz3yhbf";
  buildDepends = [ Cabal haskellSrcExts regexPosix ];
  meta = {
    homepage = "http://github.com/finnsson/template-helper";
    description = "Module to automatically extract functions from the local code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
