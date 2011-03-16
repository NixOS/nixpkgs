{cabal, primitive, vector}:

cabal.mkDerivation (self : {
  pname = "mwc-random";
  version = "0.8.0.3";
  sha256 = "1sjjayfhfkfixcwdp21cfqld9pjikdsvlb956c1a7hcs82b68xp3";
  propagatedBuildInputs = [primitive vector];
  meta = {
    description = "Fast, high quality pseudo random number generation";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

