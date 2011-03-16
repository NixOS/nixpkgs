{cabal, blazeBuilder, failure, parsec, text}:

cabal.mkDerivation (self : {
  pname = "hamlet";
  version = "0.6.1.2";
  sha256 = "0aqrjdbqb99nz3snnsrgkd6bnaj1m3bdm8kj9agd3qgv8lv90knn";
  propagatedBuildInputs =
    [blazeBuilder failure parsec text];
  meta = {
    description = "Haml-like template files that are compile-time checked";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
