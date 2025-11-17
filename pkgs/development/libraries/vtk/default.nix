{
  callPackage,
  fetchpatch2,
}:
let
  mkVtk = initArgs: callPackage (import ./generic.nix initArgs) { };
in
{
  vtk_9_5 = mkVtk {
    version = "9.5.2";
    sourceSha256 = "sha256-zuZLmNJw/3MC2vHvE0WN/11awey0XUdyODX399ViyYk=";
  };
}
