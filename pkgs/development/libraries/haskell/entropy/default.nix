{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.3.2";
  sha256 = "1kk0vmfmfqcsw0pzbii9rvz32fvhvxqpn6p6jw6q2x33z6gm5f9x";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
