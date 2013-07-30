{ cabal, numtypeTf, time }:

cabal.mkDerivation (self: {
  pname = "dimensional-tf";
  version = "0.2";
  sha256 = "0j23iamgcm7wy6y7i7diq5nnaimpsz0vvb1yrmyh0qz792d60fw1";
  buildDepends = [ numtypeTf time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
