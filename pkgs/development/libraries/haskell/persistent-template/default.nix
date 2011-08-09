{ cabal, monadControl, persistent, text, webRoutesQuasi }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "0.5.1";
  sha256 = "163j36pm6fl64m4h8kgj9h19snh026ia1166p3c6rjw86qi9fk0r";
  buildDepends = [ monadControl persistent text webRoutesQuasi ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Type-safe, non-relational, multi-backend persistence.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
