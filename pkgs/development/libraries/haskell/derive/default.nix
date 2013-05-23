{ cabal, filepath, haskellSrcExts, syb, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.11";
  sha256 = "0934k49kpp32wffpvpk2sia7frd9ik56k6ghy6d6j31cabxf9m8r";
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
