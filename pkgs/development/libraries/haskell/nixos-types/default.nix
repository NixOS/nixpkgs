{ cabal, regexPosix }:

cabal.mkDerivation (self: {
  pname = "nixos-types";
  version = "1.2";
  sha256 = "140qk6wqq87qfk471cnhrg135fnqv0vfmfxh8kj14ar2kxvzrr8w";
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
