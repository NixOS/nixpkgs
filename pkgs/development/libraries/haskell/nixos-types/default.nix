{ cabal, regexPosix }:

cabal.mkDerivation (self: {
  pname = "nixos-types";
  version = "1.0";
  sha256 = "0zg2vz790cacl1hlhzbfpb8zw5k19v4p43ynz1wdgg6sfzvwk43s";
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
