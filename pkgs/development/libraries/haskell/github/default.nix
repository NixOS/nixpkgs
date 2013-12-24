{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, hashable, HTTP, httpConduit, httpTypes, network, text
, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.7.3";
  sha256 = "0cb7smydndigkcib4y8pbsycsqyzg45g5vrglyq1h245rd4j6s37";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure
    hashable HTTP httpConduit httpTypes network text time
    unorderedContainers vector
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
