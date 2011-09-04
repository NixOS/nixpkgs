{ cabal, attoparsecText, cssText, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.0.1";
  sha256 = "1rycdjl7b7bk100vgdwy6iighdqsbsyvrklp0zqbl1x45abph9pc";
  buildDepends = [
    attoparsecText cssText network tagsoup text utf8String
  ];
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
