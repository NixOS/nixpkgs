{ cabal, Cabal, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-posix";
  version = "0.95.1";
  sha256 = "02pgxwbgz738kpdmsg18xs6kmq6my5hqd9cl4rm7cg2v39di9vbl";
  buildDepends = [ Cabal regexBase ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
