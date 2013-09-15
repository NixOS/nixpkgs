{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, HTTP, httpConduit, httpTypes, network, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.7.1";
  sha256 = "0aipaamd7gn5f79f451v8ifjs5g8b40g9w4kvi1i62imsh0zhh90";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure HTTP
    httpConduit httpTypes network text time unorderedContainers vector
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
