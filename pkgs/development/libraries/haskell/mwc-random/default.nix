{cabal, primitive, vector}:

cabal.mkDerivation (self : {
  pname = "mwc-random";
  version = "0.8.0.2";
  sha256 = "1lry31abyz6wh3x8ipclgkfc889azs7mw2ppp9kpdlx41wbzhdj6";
  propagatedBuildInputs = [primitive vector];
  meta = {
    description = "Fast, high quality pseudo random number generation";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

