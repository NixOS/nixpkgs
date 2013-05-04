{ cabal, MonadCatchIOMtl, mtl, network, parsec, xhtml }:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.8.4";
  sha256 = "1h0ynrrda18g5pn1sw2n94rhhp3k39nb7wmx53b52dhxkp2izlgn";
  buildDepends = [ MonadCatchIOMtl mtl network parsec xhtml ];
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
