{ cabal, regexBase, regexTdfa }:

cabal.mkDerivation (self: {
  pname = "regex-compat-tdfa";
  version = "0.95.1.3";
  sha256 = "0wl5sqbb3rl5dai3qni8w09wlipc4n1mn9kh5zgb9xl0lcd59pjx";
  buildDepends = [ regexBase regexTdfa ];
  patchPhase = "find . -type f -exec touch {} ';'";
  meta = {
    homepage = "http://hub.darcs.net/shelarcy/regex-compat-tdfa";
    description = "Unicode Support version of Text.Regex, using regex-tdfa";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
