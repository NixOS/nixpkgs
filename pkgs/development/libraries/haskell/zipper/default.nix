{cabal, multirec} :

cabal.mkDerivation (self : {
  pname = "zipper";
  version = "0.3.1";
  sha256 = "170qjc3mbk6i96z5js745ix57i0xkgpa5h9xjiiirq9x6bfbbqyp";
  propagatedBuildInputs = [ multirec ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic zipper for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
  };
})
