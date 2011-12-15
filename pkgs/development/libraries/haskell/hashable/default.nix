{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.1.2.2";
  sha256 = "0gfg1cyd468czfv5xfhn7rz0r5s0v378c4xjlm6kkw7n10n2zg8y";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
