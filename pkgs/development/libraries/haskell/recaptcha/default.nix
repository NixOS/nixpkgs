{ cabal, HTTP, network, xhtml }:

cabal.mkDerivation (self: {
  pname = "recaptcha";
  version = "0.1.0.1";
  sha256 = "0mk2vdvm5jz8jh8xc4alsly8c9msfis0drbgg89rck1y387z2njz";
  buildDepends = [ HTTP network xhtml ];
  meta = {
    homepage = "http://github.com/jgm/recaptcha/tree/master";
    description = "Functions for using the reCAPTCHA service in web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
