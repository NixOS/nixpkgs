{cabal, blazeHtml, enumerator, monadControl, parsec, pool, text, transformers}:

cabal.mkDerivation (self : {
  pname = "persistent";
  version = "0.5.1";
  sha256 = "1m0558vi99z15q0w62a9rkz25n8djswggbad9m0il359jb3mrzsd";
  propagatedBuildInputs = [
    blazeHtml enumerator monadControl parsec pool text transformers
  ];
  meta = {
    description = "Type-safe, non-relational, multi-backend persistence";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
