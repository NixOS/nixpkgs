{cabal, pathPieces, text} :

cabal.mkDerivation (self : {
  pname = "web-routes-quasi";
  version = "0.7.1";
  sha256 = "0m5p21kbiawjpcs5c83aaypmpmx4avjcj0kzkn95zgdkqcz5kr12";
  propagatedBuildInputs = [ pathPieces text ];
  meta = {
    homepage = "http://docs.yesodweb.com/web-routes-quasi/";
    description = "Define data types and parse/build functions for web-routes via a quasi-quoted DSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
