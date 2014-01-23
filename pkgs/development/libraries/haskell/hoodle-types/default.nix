{ cabal, cereal, lens, mtl, strict, uuid }:

cabal.mkDerivation (self: {
  pname = "hoodle-types";
  version = "0.2.2";
  sha256 = "0dw2ji676nq3idb7izzzfnxzhyngf84wkapc0la43g4w4hzv1zxz";
  buildDepends = [ cereal lens mtl strict uuid ];
  jailbreak = true;
  meta = {
    description = "Data types for programs for hoodle file format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
