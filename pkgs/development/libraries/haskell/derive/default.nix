{ cabal, filepath, haskellSrcExts, syb, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.13";
  sha256 = "0lmwj66s4krh29qqmkyc3cn3j4b4mhyqvlngvmy1xaigmgib5aci";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath haskellSrcExts syb transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/derive/";
    description = "A program and library to derive instances for data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
