{ cabal, attoparsecText, enumerator, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec-text-enumerator";
  version = "0.2.0.0";
  sha256 = "149ipf5qh7wzjrnv98h6j94djr0ndzg8s4rs8h7kzbii21ynmzz5";
  buildDepends = [ attoparsecText enumerator text ];
  meta = {
    description = "Convert an attoparsec-text parser into an iteratee";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
