{cabal, monadControl, persistent, text, webRoutesQuasi}:

cabal.mkDerivation (self : {
  pname = "persistent-template";
  version = "0.5.1";
  sha256 = "163j36pm6fl64m4h8kgj9h19snh026ia1166p3c6rjw86qi9fk0r";
  propagatedBuildInputs = [monadControl persistent text webRoutesQuasi];
  meta = {
    description = "Type-safe, non-relational, multi-backend persistence";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

