{ cabal, Cabal, multirec }:

cabal.mkDerivation (self: {
  pname = "zipper";
  version = "0.4.1";
  sha256 = "19xgvqznf200akzf19mp40fg75c0gzpp38wq3n671nm90r08lgvi";
  buildDepends = [ Cabal multirec ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic zipper for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
