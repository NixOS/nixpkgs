{ cabal, convertible, mtl, text, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "HDBC";
  version = "2.4.0.0";
  sha256 = "1zwkrr0pbgxi2y75n2sjr3xs8xa3pxbmnqg3phqkjqcz3j4gcq6y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ convertible mtl text time utf8String ];
  meta = {
    homepage = "https://github.com/hdbc/hdbc";
    description = "Haskell Database Connectivity";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
