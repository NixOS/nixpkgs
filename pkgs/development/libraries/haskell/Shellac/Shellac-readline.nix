{ cabal, Cabal, readline, Shellac }:

cabal.mkDerivation (self: {
  pname = "Shellac-readline";
  version = "0.9";
  sha256 = "3edffecf2225c199f0a4df55e3685f7deee47755ae7f8d03f5da7fac3c2ab878";
  buildDepends = [ Cabal readline Shellac ];
  meta = {
    description = "Readline backend module for Shellac";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
