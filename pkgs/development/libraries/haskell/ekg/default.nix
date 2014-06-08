{ cabal, aeson, ekgCore, filepath, network, snapCore, snapServer
, text, time, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "ekg";
  version = "0.4.0.0";
  sha256 = "1w448w17yp80zmb27yl90k3gz0nx3wxj52488lclmiapr6q4fgp8";
  buildDepends = [
    aeson ekgCore filepath network snapCore snapServer text time
    transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/tibbe/ekg";
    description = "Remote monitoring of processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
