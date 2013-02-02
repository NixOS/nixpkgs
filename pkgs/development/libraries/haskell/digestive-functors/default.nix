{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.6.0.0";
  sha256 = "1h56nl1rszm098gwrdhm5w63mrnfjp1brfrk5hlj238nmj0djgcd";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
