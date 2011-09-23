{ cabal, HDBC, mtl, odbc, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "HDBC-odbc";
  version = "2.3.1.0";
  sha256 = "0vza38ggs863wjh25xnwslwlin68166ywws72bs766rl0rq7fkf4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HDBC mtl time utf8String ];
  extraLibraries = [ odbc ];
  noHaddock = true;
  meta = {
    homepage = "http://software.complete.org/hdbc-odbc";
    description = "ODBC driver for HDBC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
