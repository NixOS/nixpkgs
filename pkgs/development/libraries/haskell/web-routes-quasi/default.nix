{ cabal, pathPieces, text }:

cabal.mkDerivation (self: {
  pname = "web-routes-quasi";
  version = "0.7.1.1";
  sha256 = "1rqbymi0n7kdhl272qfjhx9s3gspd5k0bjrhclj9l8mjf033vdmf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ pathPieces text ];
  meta = {
    homepage = "http://docs.yesodweb.com/web-routes-quasi/";
    description = "Define data types and parse/build functions for web-routes via a quasi-quoted DSL (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
