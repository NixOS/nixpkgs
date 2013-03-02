{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, HTTP, httpConduit, httpTypes, network, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.5.0";
  sha256 = "1zq9cwvpd6s8xd1ki2ifsj79vd4rm8vab9731f2p8zdm8g7mh5gd";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure HTTP
    httpConduit httpTypes network text time unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/mike-burns/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
