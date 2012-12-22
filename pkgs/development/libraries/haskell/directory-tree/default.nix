{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "directory-tree";
  version = "0.11.0";
  sha256 = "07vqwnzbwfjvlwcl50x5jl9yzvqfln0m4k4lam9r5n49wv7p01c9";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://brandon.si/code/directory-tree-module-released/";
    description = "A simple directory-like tree datatype, with useful IO functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
