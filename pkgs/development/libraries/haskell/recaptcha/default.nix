{ cabal, HTTP, network, xhtml }:

cabal.mkDerivation (self: {
  pname = "recaptcha";
  version = "0.1.0.2";
  sha256 = "04sdfp6bmcd3qkz1iqxijfiqa4qf78m5d16r9gjv90ckqf68kbih";
  buildDepends = [ HTTP network xhtml ];
  meta = {
    homepage = "http://github.com/jgm/recaptcha/tree/master";
    description = "Functions for using the reCAPTCHA service in web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
