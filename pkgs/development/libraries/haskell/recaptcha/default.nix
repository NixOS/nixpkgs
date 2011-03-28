{cabal, HTTP, network, xhtml}:

cabal.mkDerivation (self : {
  pname = "recaptcha";
  version = "0.1";
  sha256 = "de00e6e3aadd99a1cd036ce4b413ebe02d59c1b9cfd3032f122735cca1f25144";
  propagatedBuildInputs = [HTTP network xhtml];
  meta = {
    description = "Functions for using the reCAPTCHA service in web applications";
  };
})

