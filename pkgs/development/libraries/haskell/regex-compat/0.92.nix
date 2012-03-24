{ cabal, regexBase, regexPosix }:

cabal.mkDerivation (self: {
  pname = "regex-compat";
  version = "0.92";
  sha256 = "430d251bd704071fca1e38c9b250543f00d4e370382ed552ac3d7407d4f27936";
  buildDepends = [ regexBase regexPosix ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
