{ cabal, regexBase, regexPosix }:

cabal.mkDerivation (self: {
  pname = "regex-compat";
  version = "0.71.0.1";
  sha256 = "904552f7d690686b2602f37494827d09b09fc0a8a2565522b61847bec8d1de8d";
  buildDepends = [ regexBase regexPosix ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
