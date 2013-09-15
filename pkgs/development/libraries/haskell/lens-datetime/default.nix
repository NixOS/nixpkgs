{ cabal, lens, time }:

cabal.mkDerivation (self: {
  pname = "lens-datetime";
  version = "0.1.1";
  sha256 = "0p93211ibq1rkh4aj69xdwan0338k35vb5qyf7zp761nghnk3d47";
  buildDepends = [ lens time ];
  meta = {
    homepage = "http://github.com/klao/lens-datetime";
    description = "Lenses for Data.Time.* types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
