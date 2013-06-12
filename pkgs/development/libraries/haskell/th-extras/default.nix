{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "th-extras";
  version = "0.0.0.2";
  sha256 = "15sqf2jjnqcssq8hp80fk0ysgwqykjjc31gvvmzg4sypskpjs8cl";
  buildDepends = [ syb ];
  meta = {
    homepage = "https://github.com/mokus0/th-extras";
    description = "A grab bag of functions for use with Template Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
