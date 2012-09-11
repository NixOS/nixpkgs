{ cabal }:

cabal.mkDerivation (self: {
  pname = "multirec";
  version = "0.7.3";
  sha256 = "0k1wbjsvkl08nwjikflc8yyalk654mf8bvi1rhm28i4na52myi5y";
  noHaddock = true;
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic programming for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
