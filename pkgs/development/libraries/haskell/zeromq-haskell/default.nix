{ cabal, Cabal, zeromq }:

cabal.mkDerivation (self: {
  pname = "zeromq-haskell";
  version = "0.8.3";
  sha256 = "1gp85fbgylsqkxacgdxv4ifvgvwca03gy88raphqhrnk59bmjgzd";
  buildDepends = [ Cabal ];
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
