{cabal, attoparsec, text} :

cabal.mkDerivation (self : {
  pname = "attoparsec-text";
  version = "0.8.5.1";
  sha256 = "1in0ziqjf2hvlv6yay2b5xkm35j1szzwdfapn5mpflv64qi33i0z";
  propagatedBuildInputs = [ attoparsec text ];
  meta = {
    homepage = "http://patch-tag.com/r/felipe/attoparsec-text/home";
    description = "Fast combinator parsing for texts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
