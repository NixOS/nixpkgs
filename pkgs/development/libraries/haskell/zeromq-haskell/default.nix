{ cabal, zeromq }:

cabal.mkDerivation (self: {
  pname = "zeromq-haskell";
  version = "0.8.2";
  sha256 = "0wi3s3ygxd15jbj5bpq6xvrsjsm94hhj6na8r45j241j0cgr322x";
  extraLibraries = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 2.1.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
