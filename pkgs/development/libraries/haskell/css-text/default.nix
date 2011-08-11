{ cabal, attoparsecText, text }:

cabal.mkDerivation (self: {
  pname = "css-text";
  version = "0.1.0";
  sha256 = "1yns9qm817ga9vsf75maai1fyqds9svawf8xsc2fq5wlicvb3h6n";
  buildDepends = [ attoparsecText text ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "CSS parser and renderer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
