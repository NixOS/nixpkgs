{
  callPackage,
  fetchpatch2,
}:
let
  mkVtk = initArgs: callPackage (import ./generic.nix initArgs) { };
in
{
  vtk_9_5 = mkVtk {
    version = "9.5.1";
    sourceSha256 = "sha256-FEQ2YcewldBbTjdvs/QGE/Fz40/J1GWCNOnsHWJKYY8=";
  };
}
