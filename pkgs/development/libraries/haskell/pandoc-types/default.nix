{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.9.1";
  sha256 = "1174nkaig0g71n3kqrhgqn7xmr9rni3l3dh1xpypc0ksjm0ym21i";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
