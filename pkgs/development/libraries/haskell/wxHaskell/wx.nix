{cabal, stm, wxcore}:

cabal.mkDerivation (self : {
  pname = "wx";
  version = "0.11.1.2";
  sha256 = "d407e191391ec977552932ffbfc86ce7826b56208bbcbc1262d3fc65fe1c2337";
  propagatedBuildInputs = [stm wxcore];
  meta = {
    description = "wxHaskell";
  };
})  

