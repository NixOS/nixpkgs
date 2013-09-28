{ cabal }:

cabal.mkDerivation (self: {
  pname = "groups";
  version = "0.4.0.0";
  sha256 = "1kp8h3617cimya8nnadljyy4vk66dzl5nzfm900k2gh3ci8kja6k";
  meta = {
    description = "Haskell 98 groups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
