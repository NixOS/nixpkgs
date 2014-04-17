{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "explicit-exception";
  version = "0.1.7.2";
  sha256 = "0zncj57mpngszl7jz3khhd4dajzis7aag0ad62hc8rkrv2j8f5q4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Exception";
    description = "Exceptions which are explicit in the type signature";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
