{ cabal, async, exceptions, QuickCheck, semigroups, tasty
, tastyHunit, tastyQuickcheck, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq4-haskell";
  version = "0.5";
  sha256 = "1gimkcaa1n9c85v44yl4n3ljh0xv23pwgbds5g1x8n47x8s0ak9g";
  buildDepends = [ async exceptions semigroups transformers ];
  testDepends = [
    async QuickCheck tasty tastyHunit tastyQuickcheck
  ];
  pkgconfigDepends = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 4.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
