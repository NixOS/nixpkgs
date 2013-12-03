{ cabal, bert, Cabal, haskellNames, haskellPackages, haskellSrcExts
, mtl, utf8String
}:

cabal.mkDerivation (self: {
  pname = "ariadne";
  version = "0.1.2.1";
  sha256 = "1gx6jrv3s86h02cjx8pvqyklp445ljiysx29hg39qykyhi1q5a3z";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    bert Cabal haskellNames haskellPackages haskellSrcExts mtl
    utf8String
  ];
  meta = {
    homepage = "https://github.com/feuerbach/ariadne";
    description = "Go-to-definition for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
