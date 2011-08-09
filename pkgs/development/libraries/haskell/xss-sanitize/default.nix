{ cabal, network, tagsoup, utf8String }:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.2.6";
  sha256 = "18bkvrrkc0ga0610f8g3vghq0ib1yczn2n2zbzv7kg7m6bqgx2y5";
  buildDepends = [ network tagsoup utf8String ];
  meta = {
    homepage = "http://github.com/gregwebs/haskell-xss-sanitize";
    description = "sanitize untrusted HTML to prevent XSS attacks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
