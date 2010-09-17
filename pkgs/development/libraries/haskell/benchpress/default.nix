{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "benchpress";
  version = "0.2.2";
  sha256 = "185j2viimr1vbbgh9havdj2nskim8apih1fyvwln76jfrwypy194";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Benchmarks actions and produces statistics such as min, mean, and median execution time.";
  };
})

