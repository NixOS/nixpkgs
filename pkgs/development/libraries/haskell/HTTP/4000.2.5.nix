{ cabal, caseInsensitive, conduit, deepseq, httpdShed, httpTypes
, HUnit, mtl, network, parsec, pureMD5, split, testFramework
, testFrameworkHunit, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.5";
  sha256 = "03ij1zkykc438x2r1szz6ddvfhrjywlx61nrz377srcpbdmhxpb7";
  buildDepends = [ mtl network parsec ];
  testDepends = [
    caseInsensitive conduit deepseq httpdShed httpTypes HUnit mtl
    network pureMD5 split testFramework testFrameworkHunit wai warp
  ];
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
