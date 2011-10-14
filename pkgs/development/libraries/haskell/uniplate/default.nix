{ cabal, hashable, syb, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.3";
  sha256 = "14p10zhsa9ws0rn2nm0gi25bdyhhs83b6qv8bjyywb02sh15xhkw";
  buildDepends = [ hashable syb unorderedContainers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/uniplate/";
    description = "Help writing simple, concise and fast generic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
