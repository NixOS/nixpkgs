{cabal, parallel}:

cabal.mkDerivation (self : {
  pname = "strict-concurrency";
  version = "0.2.1";
  sha256 = "8838600033bde2ce7ca6bd95a3815412da67244b57dfc0e2246a8f2469f5fd9c";
  propagatedBuildInputs = [parallel];
  meta = {
    description = "Strict concurrency abstractions";
  };
})  

