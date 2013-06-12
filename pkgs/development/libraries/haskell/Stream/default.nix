{ cabal, lazysmallcheck, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "Stream";
  version = "0.4.6.1";
  sha256 = "19z052rd0varq5cbw0i0f0vkbpb40kqg6i93kz2brk6a101q5llp";
  buildDepends = [ lazysmallcheck QuickCheck ];
  meta = {
    description = "A library for manipulating infinite lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
