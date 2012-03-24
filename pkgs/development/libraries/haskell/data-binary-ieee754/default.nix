{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "data-binary-ieee754";
  version = "0.4.2.1";
  sha256 = "0i0nclq8858flpp2sl3czwz6rfaykjrlzpvlfr6vlxzf8zvah9kz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ];
  meta = {
    homepage = "http://john-millikin.com/software/data-binary-ieee754/";
    description = "Parser/Serialiser for IEEE-754 floating-point values";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
