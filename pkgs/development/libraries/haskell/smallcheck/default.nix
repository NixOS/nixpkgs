{ cabal }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "0.5";
  sha256 = "10bmaifpkd5h3fp76cgbbc21q6nd0v8b3f80fjnb1ggg5zqs10dv";
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "Another lightweight testing library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
