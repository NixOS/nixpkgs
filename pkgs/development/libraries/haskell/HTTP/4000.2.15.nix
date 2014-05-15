{ cabal, caseInsensitive, conduit, conduitExtra, deepseq, httpdShed
, httpTypes, HUnit, mtl, network, parsec, pureMD5, split
, testFramework, testFrameworkHunit, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.15";
  sha256 = "1bw79hq5nzx1gab9p3d3szr0wkiv9zvf2ld9d4i48z6fnmil4qwj";
  buildDepends = [ mtl network parsec ];
  testDepends = [
    caseInsensitive conduit conduitExtra deepseq httpdShed httpTypes
    HUnit mtl network pureMD5 split testFramework testFrameworkHunit
    wai warp
  ];
  doCheck = false;
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "6.11";
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
