{cabal, blazeHtml, blazeBuilder, parsec, utf8String, failure, neither}:

cabal.mkDerivation (self : {
  pname = "hamlet";
  version = "0.5.0";
  sha256 = "92d8e099fa63fe218e2c8c4da56ac86b0b0bb49139467b8f12595c4436d1ad0b";
  propagatedBuildInputs = [
    blazeHtml blazeBuilder parsec utf8String failure neither
  ];
  meta = {
    description = "Haml-like template files that are compile-time checked";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
