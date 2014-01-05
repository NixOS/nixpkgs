{ cabal, aeson, filepath, network, snapCore, snapServer, text, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "ekg";
  version = "0.3.1.3";
  sha256 = "1d8ly1lc92gh26bdqg3ql6n2iai3nyvwic6sj8pani58iv0p4ppc";
  buildDepends = [
    aeson filepath network snapCore snapServer text time transformers
    unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/tibbe/ekg";
    description = "Remote monitoring of processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
