{ cabal, exceptions, network, transformers }:

cabal.mkDerivation (self: {
  pname = "network-simple";
  version = "0.3.1";
  sha256 = "0bk015d0np07887flah76vgrgrqaqj4x1sdxmghvazj8c78nkan8";
  buildDepends = [ exceptions network transformers ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/k0001/network-simple";
    description = "Simple network sockets usage patterns";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
