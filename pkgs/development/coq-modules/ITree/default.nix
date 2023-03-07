{ lib, mkCoqDerivation, coq, version ? null , paco, coq-ext-lib }:

mkCoqDerivation rec {
  pname = "InteractionTrees";
  owner = "DeepSpec";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.version [
    { case = range "8.13" "8.17";  out = "5.1.0"; }
    { case = range "8.10" "8.16";  out = "4.0.0"; }
  ] null;
  release."5.1.0".sha256 = "sha256-ny7Mi1KgWADiFznkNJiRgD7Djc5SUclNgKOmWRxK+eo=";
  release."4.0.0".sha256 = "0h5rhndl8syc24hxq1gch86kj7mpmgr89bxp2hmf28fd7028ijsm";
  releaseRev = v: "${v}";
  propagatedBuildInputs = [ coq-ext-lib paco ];
  meta = {
    description = "A Library for Representing Recursive and Impure Programs in Coq";
    maintainers = with lib.maintainers; [ larsr ];
  };
}
