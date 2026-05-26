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

  vtk_9_6 = mkVtk {
    version = "9.6.0";
    sourceSha256 = "sha256-130YBpT6r9yBZXi5pTZR9nkOeZYVgRv7uRAYZho7uPI=";
  };
}
