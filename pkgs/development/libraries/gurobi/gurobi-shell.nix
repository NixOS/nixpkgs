# Primarily used to test GUROBI, and as a template for other
# shells using it.

with import <nixpkgs> {};
let
  #TODO inherit gurobiPlatform from package
  gurobiPlatform = "linux64";
  myGurobi = (import ./default.nix);
in stdenv.mkDerivation  {
  name = "gurobi-shell";
  buildInputs = [ myGurobi ];
  shellHook = ''
   export GUROBI_HOME="${myGurobi.out}/${gurobiPlatform}"
   export GUROBI_PATH="${myGurobi.out}/${gurobiPlatform}"
   export GRB_LICENSE_FILE="$HOME/gurobi.lic"
  '';
}  