{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, hashable, HTTP, httpConduit, httpTypes, network, text
, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.7.4";
  sha256 = "1yalhixisjv1n9ihik3h6ya25f0066dd422nbpfysj9093hv3a5w";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure
    hashable HTTP httpConduit httpTypes network text time
    unorderedContainers vector
  ];
  jailbreak = true;
  patchPhase = ''
    sed -i -e '/^import Data.Conduit (ResourceT)/d' Github/Private.hs
  '';
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
