{ cabal, caseInsensitive, conduit, conduitExtra, deepseq, httpdShed
, httpTypes, HUnit, mtl, network, parsec, pureMD5, split
, testFramework, testFrameworkHunit, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.17";
  sha256 = "1701mgf1gw00nxd70kkr86yl80qxy63rpqky2g9m2nfr6y4y5b59";
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
