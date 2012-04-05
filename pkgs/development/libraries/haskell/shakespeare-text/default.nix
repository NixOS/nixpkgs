{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.0.0";
  sha256 = "1bsvjmkjlqwmgbv1ki7a8djdfqvdcx7b7586a20zcgichxkkzgf6";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Interpolation with quasi-quotation: put variables strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
