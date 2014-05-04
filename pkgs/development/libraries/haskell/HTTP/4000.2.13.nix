{ cabal, caseInsensitive, conduit, deepseq, httpdShed, httpTypes
, HUnit, mtl, network, parsec, pureMD5, split, testFramework
, testFrameworkHunit, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.13";
  sha256 = "1lff45nad6j2bc6waav1z95na0bif2figxiw86g2w741p7idxyy4";
  buildDepends = [ mtl network parsec ];
  testDepends = [
    caseInsensitive conduit deepseq httpdShed httpTypes HUnit mtl
    network pureMD5 split testFramework testFrameworkHunit wai warp
  ];
  jailbreak = true;
  doCheck = false;
  preConfigure = self.stdenv.lib.optional (self.stdenv.lib.versionOlder "7.9" self.ghc.version) ''
    sed -i -e 's|Extensions: |Extensions: FlexibleContexts, |' HTTP.cabal
  '';
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
