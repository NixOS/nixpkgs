{ cabal, Cabal, extensibleExceptions, mtl, network, parsec, xhtml
}:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.7.4";
  sha256 = "1fiild4djzhyz683kwwb0k4wvhd89ihbn6vncjl270xvwj5xmrbd";
  buildDepends = [
    Cabal extensibleExceptions mtl network parsec xhtml
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
