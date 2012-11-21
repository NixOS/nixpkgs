{ cabal, zeromq }:

cabal.mkDerivation (self: {
  pname = "zeromq3-haskell";
  version = "0.1.4";
  sha256 = "026b18ligbrfbg4x7vivk6r2gj9rj3vy6pm3h0s81571h6lk3dhx";
  extraLibraries = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 3.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
