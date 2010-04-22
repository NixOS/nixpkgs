{cabal, parallel}:

cabal.mkDerivation (self : {
  pname = "strict-concurrency";
  version = "0.2.3";
  sha256 = "21641b983b226e47727ff565184a5f2b312c7979ff487a5e478f5cfc82f78f18";
  propagatedBuildInputs = [parallel];
  meta = {
    description = "Strict concurrency abstractions";
  };
})  

