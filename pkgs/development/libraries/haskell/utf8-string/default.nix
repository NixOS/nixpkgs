{ cabal }:

cabal.mkDerivation (self: {
  pname = "utf8-string";
  version = "0.3.8";
  sha256 = "1h29dn0scsfkhmkg14ywq9178lw40ah1r36w249zfzqr02y7qxc0";
  meta = {
    homepage = "http://github.com/glguy/utf8-string/";
    description = "Support for reading and writing UTF8 Strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
