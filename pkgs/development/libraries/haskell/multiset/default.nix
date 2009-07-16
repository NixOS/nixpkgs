{cabal, syb}:

cabal.mkDerivation (self : {
  pname = "multiset";
  version = "0.1";
  sha256 = "0nh1bfis4r5yd4jd9dqwckiyrqa7j8yqn4ai676xb18rh4hwsv87";
  propagatedBuildInputs = [syb];
  meta = {
    description = "A variation of Data.Set. Multisets, sometimes also called bags, can contain multiple copies of the same key";
  };
  patchPhase = '' sed -i 's/containers/containers, syb/' *.cabal ''; # add syb to library dependency list
})  

