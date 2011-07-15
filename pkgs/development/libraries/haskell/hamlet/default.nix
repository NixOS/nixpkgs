{cabal, blazeBuilder, blazeHtml, failure, parsec, text}:

cabal.mkDerivation (self : {
  pname = "hamlet";
  version = "0.8.2.1";
  sha256 = "0798ic6qap4npw2rx42xcgmi1fcbwqvyic5x6vyyf6abvxv16925";
  propagatedBuildInputs =
    [blazeBuilder blazeHtml failure parsec text];
  meta = {
    description = "Haml-like template files that are compile-time checked";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
