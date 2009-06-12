{cabal, vacuum, gtk2hs, parallel, strictConcurrency}:

cabal.mkDerivation (self : {
  pname = "vacuum-cairo";
  version = "0.4.1";
  sha256 = "4d506fec246d40e5c983eea1dbd72735e276f882539aa3682cda9d9a33f8ddb2";
  propagatedBuildInputs = [vacuum gtk2hs parallel strictConcurrency];
  meta = {
    description = "Visualize live Haskell data structures using vacuum, graphviz and cairo";
  };
})  

