{ cabal, Cabal, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-pcre-builtin";
  version = "0.94.2.1.7.7";
  sha256 = "1c4zxfild1fbpxwqcp2jnf6iwfs0z6nc8dry09gmjykxlhisxi8s";
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
