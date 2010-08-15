{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "uniplate";
  version = "1.5.1";
  sha256 = "cfeaaaabbbe318992df0c51a0c04729b22dac244f415b80a3b388708ed9cfc33";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Uniform type generic traversals";
  };
})  

