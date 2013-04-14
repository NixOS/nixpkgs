{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, HTTP, httpConduit, httpTypes, network, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.6.0";
  sha256 = "1bg443rhh57p10q9dwx4aa2964qwg00swmdlvh1r72c343lrv1gj";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure HTTP
    httpConduit httpTypes network text time unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
