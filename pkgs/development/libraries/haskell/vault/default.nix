{ cabal }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.1.0.0";
  sha256 = "02gki0g9mwmvvizxhk6myfg3dmlqpcjjiz5c8693a060hkr0grqq";
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a typed, persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
