{ cabal, hashable, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "0.3.0.1";
  sha256 = "0aaj7avg3rd2bvjjcny7wjdif60ikk7q49896g12jnczi5ba97ml";
  buildDepends = [ hashable text ];
  meta = {
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
