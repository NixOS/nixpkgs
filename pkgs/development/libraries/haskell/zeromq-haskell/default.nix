{ cabal, zeromq }:

cabal.mkDerivation (self: {
  pname = "zeromq-haskell";
  version = "0.8.1";
  sha256 = "19fl3nd548yj6d6c3jqr6lxk6y033qa68jgnc5aq5w8kmlpn70mc";
  extraLibraries = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "bindings to zeromq";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
