{cabal, bktrees, fgl, graphviz, pandoc}:

cabal.mkDerivation (self : {
  pname = "Graphalyze";
  version = "0.10.0.1";
  sha256 = "8f273de41c7c340d2c7c8b4797d30535e4038616055099cc52bc5d21c10d9f22";
  propagatedBuildInputs = [bktrees fgl graphviz pandoc ];
  meta = {
    description = "A library to use graph theory analysis";
    license = "OtherLicene";
  };
})  

