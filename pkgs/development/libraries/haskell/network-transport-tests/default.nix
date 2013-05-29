{ cabal, ansiTerminal, mtl, networkTransport, random }:

cabal.mkDerivation (self: {
  pname = "network-transport-tests";
  version = "0.1.0.1";
  sha256 = "15vdkjq10mm378iyci1lpj6b77m7sil5mk3yhzf6vcbfj54pwca6";
  buildDepends = [ ansiTerminal mtl networkTransport random ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Unit tests for Network.Transport implementations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
