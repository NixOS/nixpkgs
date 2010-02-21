{ ghc, cabal, X11, utf8String, pkgconfig, libXft }:
cabal.mkDerivation (self : {
  pname = "X11-xft";
  version = "0.3";
  sha256 = "48892d0d0a90d5b47658877facabf277bf8466b7388eaf6ce163b843432a567d";
  buildInputs = [ ghc pkgconfig libXft ];
  propagatedBuildInputs = [ X11 utf8String ];
  meta = {
    homepage = http://hackage.haskell.org/package/X11-xft;
    description = "Haskell bindings to the Xft and some Xrender parts";
    maintainers = with self.stdenv.lib.maintainers; [ astsmtl ];
    platforms = with self.stdenv.lib.platforms; linux;
  };
})
