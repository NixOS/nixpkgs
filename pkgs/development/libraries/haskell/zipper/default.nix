{ cabal, multirec }:

cabal.mkDerivation (self: {
  pname = "zipper";
  version = "0.4.2";
  sha256 = "1r8092amq5w9gl5szycl1r7wx87xnmkcapdzcwfa4c3pvxrhjy44";
  buildDepends = [ multirec ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic zipper for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
