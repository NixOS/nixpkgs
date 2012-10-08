{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "edit-distance";
  version = "0.2.1.1";
  sha256 = "1d8h38cn3azvsp2dp5gycglm5bwwd8plbag8ypi38yj6c35a82yn";
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
