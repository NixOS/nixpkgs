{ cabal, Cabal, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-posix";
  version = "0.94.2";
  sha256 = "ea0c1ed0ab49ade4dba1eea7a42197652ccb18b7a98c4040e37ba11d26f33067";
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
