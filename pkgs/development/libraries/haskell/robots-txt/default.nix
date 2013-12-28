{ cabal, attoparsec, heredoc, hspec, QuickCheck, transformers }:

cabal.mkDerivation (self: {
  pname = "robots-txt";
  version = "0.4.0.0";
  sha256 = "1z0bn4v6fx0nx1hr4bbxi5k2c8bv6x3d4pywpav67m5pswxb2yp7";
  buildDepends = [ attoparsec ];
  testDepends = [ attoparsec heredoc hspec QuickCheck transformers ];
  meta = {
    homepage = "http://github.com/meanpath/robots";
    description = "Parser for robots.txt";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
