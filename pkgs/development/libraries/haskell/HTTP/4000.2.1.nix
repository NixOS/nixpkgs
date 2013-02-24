{ cabal, httpdShed, HUnit, mtl, network, parsec, split
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.1";
  sha256 = "01076rk7ly5228pszn54x4nqc6rqq1xw11ij9ajvhzf419islh0a";
  buildDepends = [ mtl network parsec ];
  testDepends = [
    httpdShed HUnit network split testFramework testFrameworkHunit
  ];
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
