{ cabal, haskellSrcExts, syb, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.4";
  sha256 = "0gmj24qzh3vyvp0a44v4mf1qpkrg4d9q0m15d0yfbyzrimyjx1c7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ haskellSrcExts syb transformers uniplate ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/derive/";
    description = "A program and library to derive instances for data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
