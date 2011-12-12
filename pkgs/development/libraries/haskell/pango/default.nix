{ cabal, cairo, glib, gtk2hsBuildtools, libc, mtl, pango, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "pango";
  version = "0.12.2";
  sha256 = "0kf9sw2ajqlvv9n685fbif7c8x1qnz4w3y3xqql3a1rv6s3kmqba";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ cairo pango ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Pango text rendering engine";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
