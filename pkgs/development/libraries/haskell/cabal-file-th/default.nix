{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-file-th";
  version = "0.2.2";
  sha256 = "1ql2gmg3mdfkmnk1m3966npr6l1in15fzlkbn7dr1cp4s90igqhy";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://github.com/nkpart/cabal-file-th";
    description = "Template Haskell expressions for reading fields from a project's cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
