{ cabal, logict, mtl }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "1.0.4";
  sha256 = "0zqssw7r56k7gi1lxdss3f4piqa692y728rli9p81q9rbcvi3x7z";
  buildDepends = [ logict mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
