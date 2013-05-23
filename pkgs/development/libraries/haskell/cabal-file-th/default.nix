{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-file-th";
  version = "0.2.3";
  sha256 = "0kawvb5n56rkq4453l6pia3wrr6jvvdwkghi6i176n1gm2zf2ri8";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://github.com/nkpart/cabal-file-th";
    description = "Template Haskell expressions for reading fields from a project's cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
