{ cabal, caseInsensitive, conduit, deepseq, httpdShed, httpTypes
, HUnit, mtl, network, parsec, pureMD5, split, testFramework
, testFrameworkHunit, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.14";
  sha256 = "1js5r3rpy5wx0h29qsd3sfazqj0svfdcv13nsvwqi9jnwik8041c";
  buildDepends = [ mtl network parsec ];
  testDepends = [
    caseInsensitive conduit deepseq httpdShed httpTypes HUnit mtl
    network pureMD5 split testFramework testFrameworkHunit wai warp
  ];
  jailbreak = true;
  doCheck = false;
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "6.11";
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
