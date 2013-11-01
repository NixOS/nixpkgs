{ cabal, comonad, semigroupoids, transformers }:

cabal.mkDerivation (self: {
  pname = "data-lens";
  version = "2.10.4";
  sha256 = "1pzswlpphpipsqja825pyqjixp4akc5nmw9y61jwv6r4vsgdpg5i";
  buildDepends = [ comonad semigroupoids transformers ];
  meta = {
    homepage = "http://github.com/roconnor/data-lens/";
    description = "Haskell 98 Lenses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
