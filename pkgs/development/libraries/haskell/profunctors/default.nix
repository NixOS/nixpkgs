{ cabal, comonad, semigroupoids, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "4.0.3";
  sha256 = "0rdr75nqzxaly47vnpbmska608k457dgpzi5wfcqhmw996kh5inh";
  buildDepends = [ comonad semigroupoids tagged transformers ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
