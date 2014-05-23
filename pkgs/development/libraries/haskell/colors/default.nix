{ cabal, profunctors }:

cabal.mkDerivation (self: {
  pname = "colors";
  version = "0.1.1";
  sha256 = "1i1n05prbp0l3xgx0w2lxzc5r81pcmbzclsamdr7fmjvhvh8blqm";
  buildDepends = [ profunctors ];
  meta = {
    homepage = "https://github.com/fumieval/colors";
    description = "A type for colors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
