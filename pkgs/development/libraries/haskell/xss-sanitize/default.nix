{ cabal, attoparsec, cssText, network, tagsoup, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.1.1";
  sha256 = "1nv28nk1fdxym1vv50wgkyfkinpr3bd7cn6vwi41x5iqy9vgjjpl";
  buildDepends = [
    attoparsec cssText network tagsoup text utf8String
  ];
  meta = {
    homepage = "http://github.com/yesodweb/haskell-xss-sanitize";
    description = "sanitize untrusted HTML to prevent XSS attacks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
