{ cabal, HUnit, monadControl, testFramework, testFrameworkHunit
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.3.0";
  sha256 = "0wbh9l7hsbgvfplxyamvpb8nq6w147zsd2yskylfmpw7kyz6yp9n";
  buildDepends = [ monadControl transformersBase ];
  testDepends = [
    HUnit monadControl testFramework testFrameworkHunit transformers
    transformersBase
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/basvandijk/lifted-base";
    description = "lifted IO operations from the base library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
