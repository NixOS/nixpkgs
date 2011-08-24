{ cabal, extensibleExceptions, MonadCatchIOMtl, mtl, network
, parsec, xhtml
}:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.8.2";
  sha256 = "09ly7bn5ck563jq1wip5w628g74xj4p1ha9rllfdck33pqrl2mgz";
  buildDepends = [
    extensibleExceptions MonadCatchIOMtl mtl network parsec xhtml
  ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/cgi/";
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
