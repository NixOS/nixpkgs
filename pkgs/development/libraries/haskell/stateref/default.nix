{ cabal, mtl, stm }:

cabal.mkDerivation (self: {
  pname = "stateref";
  version = "0.3";
  sha256 = "0hdpw6g255lj7jjvgqwhjdpzmka546vda5qjvry8gjj6nfm91lvx";
  buildDepends = [ mtl stm ];
  meta = {
    homepage = "http://code.haskell.org/~mokus/stateref/";
    description = "Abstraction for things that work like IORef";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
