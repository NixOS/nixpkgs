{cabal, blazeHtml, parsec, utf8String}:

cabal.mkDerivation (self : {
  pname = "hamlet";
  version = "0.4.0";
  sha256 = "5e05879e734fc193acc48eda48dadbf53659e937543068bcc77dc7c394f6adcd";
  propagatedBuildInputs = [blazeHtml parsec utf8String];
  meta = {
    description = "Haml-like template files that are compile-time checked";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
