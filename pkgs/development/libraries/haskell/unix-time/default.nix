{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.1.1";
  sha256 = "1b7njfs33vqmprpmbpi8hvy1lc5ryvdiy5526q8s7vkzsi2iky1p";
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
