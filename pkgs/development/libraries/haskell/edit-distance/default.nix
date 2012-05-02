{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "edit-distance";
  version = "0.2.1";
  sha256 = "1zhiyzgqmxi4mn7zn5q6rg03hgff9y5f9xizbs00069v7ncygi38";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ random ];
  meta = {
    homepage = "http://github.com/batterseapower/edit-distance";
    description = "Levenshtein and restricted Damerau-Levenshtein edit distances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
