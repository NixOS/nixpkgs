{ cabal, HUnit, monadControl, testFramework, testFrameworkHunit
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.2.2";
  sha256 = "02qjagh4a3zvad7xyvwjd6nkh44c41bqj32ddpn7ms1fv4sl0mam";
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
