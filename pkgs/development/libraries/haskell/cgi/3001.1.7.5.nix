{ cabal, mtl, network, parsec, xhtml }:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.7.5";
  sha256 = "1zdgdzkrzclf492pb9px5a490mxfxl5c1099axcxxm9wlpmf49ji";
  buildDepends = [ mtl network parsec xhtml ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/cgi/";
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
