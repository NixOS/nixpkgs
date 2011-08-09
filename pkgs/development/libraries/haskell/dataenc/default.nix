{ cabal }:

cabal.mkDerivation (self: {
  pname = "dataenc";
  version = "0.14";
  sha256 = "0q92pzm6wp4rl92ac9b2x2b6na8nzhf229myc9h3cyr3p822liw6";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Library/Data_encoding";
    description = "Data encoding library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
