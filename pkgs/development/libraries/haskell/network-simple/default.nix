{ cabal, exceptions, network, transformers }:

cabal.mkDerivation (self: {
  pname = "network-simple";
  version = "0.4";
  sha256 = "1jw0xd53c0mydh6jm6627c0d8w014r1s46fycdhavnimh7bb77cp";
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
