{cabal, transformers} :

cabal.mkDerivation (self : {
  pname = "data-accessor";
  version = "0.2.2";
  sha256 = "1jqd0qlv1yab83d5pdbzjw6q4a2kvbsar6kgczq0f0xn9gxm0qci";
  propagatedBuildInputs = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
