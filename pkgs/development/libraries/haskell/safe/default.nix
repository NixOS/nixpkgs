{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3.5";
  sha256 = "0xv409ps1h1b28v8rkg59a09z001nmpvqvwf3mdkzkyzmxfgq30j";
  meta = {
    homepage = "http://community.haskell.org/~ndm/safe/";
    description = "Library of safe (exception free) functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
