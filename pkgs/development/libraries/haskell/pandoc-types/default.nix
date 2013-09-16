{ cabal, aeson, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.12";
  sha256 = "1dn5zl6r1vvnqcsdxdd5cv0n44rbffg3sm2jxpvcv9846wpaj8qj";
  buildDepends = [ aeson syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
