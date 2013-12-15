{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, hashable, HTTP, httpConduit, httpTypes, network, text
, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.7.2";
  sha256 = "0w8m8ybzb63j1631v2a6xpm727zbj19dv98cml9fyzlxzlvlg5fs";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure
    hashable HTTP httpConduit httpTypes network text time
    unorderedContainers vector
  ];
  patches = [ ./fix-build.patch ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
