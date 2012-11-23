{ cabal, c2hs, libidn, text }:

cabal.mkDerivation (self: {
  pname = "gnuidn";
  version = "0.2";
  sha256 = "0xk72p3z1lwlmab0jcf7m48p5pncgz00hb7l96naz1gdkbq7xizd";
  buildDepends = [ text ];
  buildTools = [ c2hs ];
  extraLibraries = [ libidn ];
  pkgconfigDepends = [ libidn ];
  meta = {
    homepage = "http://john-millikin.com/software/bindings/gnuidn/";
    description = "Bindings for GNU IDN";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
