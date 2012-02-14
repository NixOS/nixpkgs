{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "xhtml";
  version = "3000.2.0.5";
  sha256 = "1gqq910pncqppb2dscxnfxvm1ly4qpb5mwmady2i4irar3gngh9v";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "https://github.com/haskell/xhtml";
    description = "An XHTML combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
