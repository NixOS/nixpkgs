{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.1";
  sha256 = "156ydqljhxp16192s4pj6h8jcvrfmj2lnsvzy0zg394wi97bxpi2";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://github.com/snoyberg/file-embed/tree/master";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
