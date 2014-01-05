{ cabal, cairo, glib, gtk2hsBuildtools, libc, mtl, pango, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "pango";
  version = "0.12.5.0";
  sha256 = "06hchdnw4nfnpb46nb1gwgpwwk41dhp0xfimnbf310idiy0pavcg";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ cairo pango ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Pango text rendering engine";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
