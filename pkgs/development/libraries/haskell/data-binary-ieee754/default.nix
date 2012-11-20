{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "data-binary-ieee754";
  version = "0.4.3";
  sha256 = "0aba7qvjvhfp9cpr65j8zs62niv9yccrardk10aaqpkz3ihc86pm";
  buildDepends = [ binary ];
  meta = {
    homepage = "https://john-millikin.com/software/data-binary-ieee754/";
    description = "Parser/Serialiser for IEEE-754 floating-point values";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
