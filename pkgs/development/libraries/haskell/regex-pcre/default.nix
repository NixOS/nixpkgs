{ cabal, pcre, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-pcre";
  version = "0.94.2";
  sha256 = "0p4az8z4jlrcmmyz9bjf7n90hpg6n242vq4255w2dz5v29l822wn";
  buildDepends = [ regexBase ];
  extraLibraries = [ pcre ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
