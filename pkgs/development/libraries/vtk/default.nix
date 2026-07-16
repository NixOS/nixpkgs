{
  callPackage,
  fetchpatch,
}:
let
  mkVtk = initArgs: callPackage (import ./generic.nix initArgs) { };
in
{
  vtk_9_5 = mkVtk {
    version = "9.5.2";
    sourceSha256 = "sha256-zuZLmNJw/3MC2vHvE0WN/11awey0XUdyODX399ViyYk=";
    patches = [
      (fetchpatch {
        name = "fix-gdal-3.13-const-conversion.patch";
        url = "https://github.com/Kitware/VTK/commit/2395603fdddc40c29efc64c632ae98225ca2a58e.patch";
        hash = "sha256-Gcnt1JXWPkhfNLhtk9SXYqx/0cLkjO4xiRfR8YiaY8I=";
      })
    ];
  };

  vtk_9_6 = mkVtk {
    version = "9.6.0";
    sourceSha256 = "sha256-130YBpT6r9yBZXi5pTZR9nkOeZYVgRv7uRAYZho7uPI=";
    patches = [
      (fetchpatch {
        name = "fix-gdal-3.13-const-conversion.patch";
        url = "https://github.com/Kitware/VTK/commit/2395603fdddc40c29efc64c632ae98225ca2a58e.patch";
        hash = "sha256-Gcnt1JXWPkhfNLhtk9SXYqx/0cLkjO4xiRfR8YiaY8I=";
      })
    ];
  };
}
