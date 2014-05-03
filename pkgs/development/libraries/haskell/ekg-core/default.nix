{ cabal, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "ekg-core";
  version = "0.1.0.0";
  sha256 = "19ghqj9zbb198d45bw7k9mlf2z57yq74wgbkp62b9li2ndbcpdzh";
  buildDepends = [ text unorderedContainers ];
  meta = {
    homepage = "https://github.com/tibbe/ekg-core";
    description = "Tracking of system metrics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
