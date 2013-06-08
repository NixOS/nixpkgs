{ cabal }:

cabal.mkDerivation (self: {
  pname = "hinotify";
  version = "0.3.5";
  sha256 = "00pzvqw2w3gbz8j4hiz8zxm7rki07g1iamjlbazz3kmpwcgjxi0l";
  meta = {
    homepage = "https://github.com/kolmodin/hinotify.git";
    description = "Haskell binding to inotify";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
