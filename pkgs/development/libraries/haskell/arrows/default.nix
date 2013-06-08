{ cabal, Stream }:

cabal.mkDerivation (self: {
  pname = "arrows";
  version = "0.4.4.1";
  sha256 = "1qpbpwsc3frjdngwjv3r58nfa0ik88cqh24ls47svigsz3c4n42v";
  buildDepends = [ Stream ];
  meta = {
    homepage = "http://www.haskell.org/arrows/";
    description = "Arrow classes and transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
