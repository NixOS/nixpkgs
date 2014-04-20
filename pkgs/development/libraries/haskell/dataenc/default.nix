{ cabal }:

cabal.mkDerivation (self: {
  pname = "dataenc";
  version = "0.14.0.5";
  sha256 = "13gajqbayar7x8sq3rw93i277gqd0bx1i34spshlj4b41fraxc8w";
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Library/Data_encoding";
    description = "Data encoding library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
