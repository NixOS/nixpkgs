{ cabal, regexPosix }:

cabal.mkDerivation (self: {
  pname = "nixos-types";
  version = "1.3";
  sha256 = "0kdi3q316c9irrzwl1vx764f958i5d61v2vc03356sfyy13d19sk";
  buildDepends = [ regexPosix ];
  meta = {
    homepage = "http://github.com/haskell4nix/nixos-types";
    description = "Data types representing the Nix language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
