{ cabal, curl }:

cabal.mkDerivation (self: {
  pname = "curl";
  version = "1.3.7";
  sha256 = "0i6d7732p5gn1bcvavbxcg4wd18j425mi1yjg0b29zzz3yl0qhgi";
  extraLibraries = [ curl ];
  meta = {
    description = "Haskell binding to libcurl";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
