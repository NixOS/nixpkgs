{cabal, blazeHtml, MonadCatchIOTransformers, parsec, text, transformers,
 utf8String, webRoutesQuasi}:

cabal.mkDerivation (self : {
  pname = "persistent";
  version = "0.1.0";
  sha256 = "32379f5ef937da1bf910cfaf9b6cce6326b8fba7554ef81159e6684c7ce2ca45";
  propagatedBuildInputs = [
    blazeHtml MonadCatchIOTransformers parsec text transformers
    utf8String webRoutesQuasi
  ];
  meta = {
    description = "Type-safe, non-relational, multi-backend persistence";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
