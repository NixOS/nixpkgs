{ cabal, HTTP, network, xhtml }:

cabal.mkDerivation (self: {
  pname = "recaptcha";
  version = "0.1";
  sha256 = "de00e6e3aadd99a1cd036ce4b413ebe02d59c1b9cfd3032f122735cca1f25144";
  buildDepends = [ HTTP network xhtml ];
  meta = {
    homepage = "http://github.com/jgm/recaptcha/tree/master";
    description = "Functions for using the reCAPTCHA service in web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
