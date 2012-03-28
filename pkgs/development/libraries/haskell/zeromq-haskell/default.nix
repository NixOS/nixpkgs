{ cabal, zeromq }:

cabal.mkDerivation (self: {
  pname = "zeromq-haskell";
  version = "0.8.4";
  sha256 = "0lvjszi08r5wm5ch03153y7lir6cdgqr2gnhq45j4b0kid6gkpv3";
  extraLibraries = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 2.1.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
