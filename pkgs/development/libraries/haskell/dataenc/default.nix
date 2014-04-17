{ cabal }:

cabal.mkDerivation (self: {
  pname = "dataenc";
  version = "0.14.0.6";
  sha256 = "0635aspx65wwpky0kbnlj9ly4vjw5afzvdn9glnhfxq6m6yjzp8q";
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
