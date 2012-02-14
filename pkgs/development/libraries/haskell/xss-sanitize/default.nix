{ cabal, attoparsec, Cabal, cssText, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.1";
  sha256 = "0s8nqqx5f5b07xxlda4gh0w6vmlkhbqbz36cf6glhbhhyw27jkx5";
  buildDepends = [
    attoparsec Cabal cssText network tagsoup text utf8String
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
