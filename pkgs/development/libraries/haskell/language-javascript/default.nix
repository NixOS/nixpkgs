{ cabal, alex, Cabal, happy, mtl, utf8Light }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.4.7";
  sha256 = "029ncc7hdw3pi9fbnxd0knz7wy3jpj5wcfqsxzyk5dkwji6d95x1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal mtl utf8Light ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
