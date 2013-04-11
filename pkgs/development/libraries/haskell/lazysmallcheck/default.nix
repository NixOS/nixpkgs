{ cabal }:

cabal.mkDerivation (self: {
  pname = "lazysmallcheck";
  version = "0.6";
  sha256 = "0lqggm75m1qd34lzqj3ibvnjwhjqvq16cab8zxm4yzn7j2sxzm4x";
  meta = {
    homepage = "http://www.cs.york.ac.uk/~mfn/lazysmallcheck/";
    description = "A library for demand-driven testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
