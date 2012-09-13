{ cabal, extensibleExceptions, MonadCatchIOMtl, mtl, network
, parsec, xhtml
}:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.8.3";
  sha256 = "1pacv0qxfs7l71xvf9amd7qsw5g725qbrm8r6fgdb2awyl925sf4";
  buildDepends = [
    extensibleExceptions MonadCatchIOMtl mtl network parsec xhtml
  ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/cgi/";
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
