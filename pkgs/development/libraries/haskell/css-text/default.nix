{ cabal, attoparsecText, text }:

cabal.mkDerivation (self: {
  pname = "css-text";
  version = "0.1.0.1";
  sha256 = "004ky2s6jmiliw8faja5kzp99i36qf56cixvn43n3pnq8gg26kfi";
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
