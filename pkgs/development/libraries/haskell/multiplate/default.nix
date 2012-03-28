{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "multiplate";
  version = "0.0.1.1";
  sha256 = "00rxgkvgx1rfvk15gjyyg00vqyg4j24d8d19q6rj07j2mgfvdxw6";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Multiplate";
    description = "Lightweight generic library for mutually recursive data types";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
