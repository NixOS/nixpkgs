{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "haskell-lexer";
  version = "1.0";
  sha256 = "86d0c4071295c8613eb965768cb61a0c8422fc0c429a49c7a93e93a72b185b86";
  buildDepends = [ Cabal ];
  meta = {
    description = "A fully compliant Haskell 98 lexer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
