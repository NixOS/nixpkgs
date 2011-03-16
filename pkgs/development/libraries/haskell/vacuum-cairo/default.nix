{cabal, vacuum, cairo, svgcairo, gtk, parallel, strictConcurrency}:

cabal.mkDerivation (self : {
  pname = "vacuum-cairo";
  version = "0.5";
  sha256 = "0jp3xn1h28igcg3xb97ifawx11i7adnyi0ff264w0fril9b8ylwc";
  propagatedBuildInputs =
    [vacuum cairo svgcairo gtk parallel strictConcurrency];
  meta = {
    description = "Visualize live Haskell data structures using vacuum, graphviz and cairo";
  };
})  

