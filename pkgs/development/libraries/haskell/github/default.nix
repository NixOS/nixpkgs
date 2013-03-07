{ cabal, fetchurl, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, HTTP, httpConduit, httpTypes, network, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.5.0-patched";
  src = fetchurl {
    url = "https://github.com/mike-burns/github/archive/df415af64ebd4a28f1f8e5cc726e933545efdd7e.tar.gz";
    sha256 = "1d1ya5j1qz1nf5kfkxp48gb0xbcr4fmf9y0kfpd3gxivfrdkfrig";
    name = "github-${self.version}.tar.gz";
  };
  patches = [ (fetchurl { url = "https://github.com/mike-burns/github/pull/33.patch"; sha256 = "1d0m73ygzpk5rd6ahbrf58mxca56s5sd70yrf7fn2r1bh0rlacap"; }) ];
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
