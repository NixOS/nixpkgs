{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
  paco,
  coq-ext-lib,
}:

mkCoqDerivation rec {
  pname = "InteractionTrees";
  owner = "DeepSpec";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.13" "8.20";
        out = "5.1.2";
      }
      {
        case = range "8.10" "8.16";
        out = "4.0.0";
      }
    ] null;
  release."5.1.2".sha256 = "sha256-uKJIjNXGWl0YS0WH52Rnr9Jz98Eo2k0X0qWB9hUYJMk=";
  release."5.1.1".sha256 = "sha256-VlmPNwaGkdWrH7Z6DGXRosGtjuuQ+FBiGcadN2Hg5pY=";
  release."5.1.0".sha256 = "sha256-ny7Mi1KgWADiFznkNJiRgD7Djc5SUclNgKOmWRxK+eo=";
  release."4.0.0".sha256 = "0h5rhndl8syc24hxq1gch86kj7mpmgr89bxp2hmf28fd7028ijsm";
  releaseRev = v: "${v}";
  propagatedBuildInputs = [
    coq-ext-lib
    paco
  ];
  meta = {
    description = "Library for Representing Recursive and Impure Programs in Coq";
    maintainers = with lib.maintainers; [ larsr ];
  };
}
