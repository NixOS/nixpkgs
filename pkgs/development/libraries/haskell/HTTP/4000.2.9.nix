{ cabal, caseInsensitive, conduit, deepseq, httpdShed, httpTypes
, HUnit, mtl, network, parsec, pureMD5, split, testFramework
, testFrameworkHunit, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.9";
  sha256 = "0fnf4blh7gw0cbap16ss811wr0haa2gqd0gzdbz668jk58n1gmz7";
  buildDepends = [ mtl network parsec ];
  testDepends = [
    caseInsensitive conduit deepseq httpdShed httpTypes HUnit mtl
    network pureMD5 split testFramework testFrameworkHunit wai warp
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
