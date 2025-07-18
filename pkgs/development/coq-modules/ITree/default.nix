{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
  paco,
  ExtLib,
}:

mkCoqDerivation {
  pname = "InteractionTrees";
  owner = "DeepSpec";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.version [
      (case (range "8.14" "9.1") "5.2.1")
      (case (isEq "8.13") "5.2.0+20241009")
      (case (range "8.10" "8.16") "4.0.0")
    ] null;
  release."5.2.1".sha256 = "sha256-3ExKHXIA8EnzAPzSbdB9FTN2OcLCVS5WtmrHOiN9UiQ=";
  release."5.2.0+20241009".sha256 = "sha256-eg47YgnIonCq7XOUgh9uzoKsuFCvsOSTZhgFLNNcPD0=";
  release."5.2.0+20241009".rev = "abd1c7d3935cf03f02bf90e028e6cd3d3dce7713";
  release."5.2.0".sha256 = "sha256-rKLz7ekZf/9xcQefBRsAdULmk81olzQ1W28y61vCDsY=";
  release."5.1.2".sha256 = "sha256-uKJIjNXGWl0YS0WH52Rnr9Jz98Eo2k0X0qWB9hUYJMk=";
  release."5.1.1".sha256 = "sha256-VlmPNwaGkdWrH7Z6DGXRosGtjuuQ+FBiGcadN2Hg5pY=";
  release."5.1.0".sha256 = "sha256-ny7Mi1KgWADiFznkNJiRgD7Djc5SUclNgKOmWRxK+eo=";
  release."4.0.0".sha256 = "0h5rhndl8syc24hxq1gch86kj7mpmgr89bxp2hmf28fd7028ijsm";
  release."3.2.0".sha256 = "sha256-10ckCAqSQ0I3CZKlSllI1obOgWVxDagTd7eyhrl1xpE=";
  releaseRev = v: "${v}";
  propagatedBuildInputs = [
    ExtLib
    paco
  ];
  meta = {
    description = "Library for Representing Recursive and Impure Programs in Coq";
    maintainers = with lib.maintainers; [ larsr ];
  };
}
