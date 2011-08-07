{cabal, MonadCatchIOMtl, ghc, ghcMtl, ghcPaths, haskellSrc, mtl,
 utf8String} :

cabal.mkDerivation (self : {
  pname = "hint";
  version = "0.3.3.2";
  sha256 = "1qm74hjz8cxypvavcw7s094zg9ic3r1ll2lj3y159ipc79cw2sn1";
  propagatedBuildInputs = [
    MonadCatchIOMtl ghc ghcMtl ghcPaths haskellSrc mtl utf8String
  ];
  meta = {
    homepage = "http://projects.haskell.org/hint";
    description = "Runtime Haskell interpreter (GHC API wrapper)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
