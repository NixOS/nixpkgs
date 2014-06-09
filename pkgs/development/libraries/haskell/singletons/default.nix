{ cabal, Cabal, constraints, filepath, mtl, tasty, tastyGolden
, thDesugar
}:

cabal.mkDerivation (self: {
  pname = "singletons";
  version = "1.0";
  sha256 = "1rd1728wghhqlg2djd7az8i01rf4i3wwwcnz2v43a39jjvhlklkg";
  buildDepends = [ mtl thDesugar ];
  testDepends = [ Cabal constraints filepath tasty tastyGolden ];
  noHaddock = true;
  patches = self.stdenv.lib.optional self.stdenv.isDarwin ./test.patch;
  meta = {
    homepage = "http://www.cis.upenn.edu/~eir/packages/singletons";
    description = "A framework for generating singleton types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
