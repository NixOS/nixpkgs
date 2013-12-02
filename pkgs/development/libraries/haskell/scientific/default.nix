{ cabal, deepseq, hashable, smallcheck, tasty, tastySmallcheck
, text
}:

cabal.mkDerivation (self: {
  pname = "scientific";
  version = "0.1.0.0";
  sha256 = "1x3c8z1d7nhr1z5dlbs60pxfrgclfbwjhrkpvr0jnz0fpy2m9x5r";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ smallcheck tasty tastySmallcheck text ];
  meta = {
    homepage = "https://github.com/basvandijk/scientific";
    description = "Arbitrary-precision floating-point numbers represented using scientific notation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
  doCheck = false;
})
