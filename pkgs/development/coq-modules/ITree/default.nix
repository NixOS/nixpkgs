{ lib, mkCoqDerivation, coq, paco, coq-ext-lib
  , version ? null, origin ? null}:

with lib; mkCoqDerivation rec {
  pname = "InteractionTrees";
  owner = "DeepSpec";
  inherit version origin;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.10" "8.13";  out = "4.0.0"; }
  ] null;
  release."4.0.0".sha256 = "0h5rhndl8syc24hxq1gch86kj7mpmgr89bxp2hmf28fd7028ijsm";
  releaseRev = v: "${v}";
  propagatedBuildInputs = [ coq-ext-lib paco ];
  meta = {
    description = "A Library for Representing Recursive and Impure Programs in Coq";
    maintainers = with maintainers; [ larsr ];
  };
}
