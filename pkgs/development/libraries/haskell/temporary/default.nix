{ cabal, exceptions, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "temporary";
  version = "1.2.0.1";
  sha256 = "12z8qnqn1fg9ymaav5ds7gk067lmj0bv1lhhxcnvmvjcpk1l5b54";
  buildDepends = [ exceptions filepath transformers ];
  jailbreak = true;
  meta = {
    homepage = "http://www.github.com/batterseapower/temporary";
    description = "Portable temporary file and directory support for Windows and Unix, based on code from Cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
