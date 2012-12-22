{ cabal }:

cabal.mkDerivation (self: {
  pname = "dataenc";
  version = "0.14.0.4";
  sha256 = "0xnn90nyz4m0rbzykkr5p9270s8dq2bfiz5j7qyzyy5m8vbl15bw";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Library/Data_encoding";
    description = "Data encoding library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
