{cabal}:

cabal.mkDerivation (self : {
  pname = "cautious-file";
  version = "0.1.5";
  sha256 = "0d7b7bf530476b89ffc22bf6e586402b0fd6fd5571cc941df08838c5a890ad01";
  meta = {
    description = "Ways to write a file cautiously";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

