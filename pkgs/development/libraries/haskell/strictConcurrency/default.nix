{cabal, parallel, deepseq}:

cabal.mkDerivation (self : {
  pname = "strict-concurrency";
  version = "0.2.4.1";
  sha256 = "0939212dd0cc3b9bd228dfbb233d9eccad22ca626752d9bad8026ceb0a5c1a89";
  propagatedBuildInputs = [parallel deepseq];
  meta = {
    description = "Strict concurrency abstractions";
  };
})  

