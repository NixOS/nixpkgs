{cabal, stm, wxcore}:

cabal.mkDerivation (self : {
  pname = "wx";
  version = "0.12.1.6";
  sha256 = "1p0gn46gk1abin095va22n9bycxhm2cq1vyvwiypcdq7jq541lhk";
  propagatedBuildInputs = [stm wxcore];
  meta = {
    description = "wxHaskell";
  };
})

