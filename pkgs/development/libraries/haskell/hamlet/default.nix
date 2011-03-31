{cabal, blazeBuilder, blazeHtml, failure, parsec, text, jsonEnumerator, jsonTypes}:

cabal.mkDerivation (self : {
  pname = "hamlet";
  version = "0.7.3";
  sha256 = "1knapi8506kqm6pbl1qdr3vm579z2dn6q3h3ahzwbxqjafy7pnj9";
  propagatedBuildInputs =
    [blazeBuilder blazeHtml failure parsec text jsonEnumerator jsonTypes];
  meta = {
    description = "Haml-like template files that are compile-time checked";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
