{
  callPackage,
  fetchpatch2,
}:
let
  mkVtk = initArgs: callPackage (import ./generic.nix initArgs) { };
in
{
  vtk_9_5 = mkVtk {
    version = "9.5.0";
    sourceSha256 = "sha256-BK6GJGuVV8a2GvvFNKbfCZJE+8jzk3+C5rwFcJU6+H0=";
    patches = [
      # https://gitlab.kitware.com/vtk/vtk/-/issues/19699
      (fetchpatch2 {
        url = "https://gitlab.kitware.com/vtk/vtk/-/commit/6b4f7b853675c63e4831c366ca8f78e320c1bfb5.diff";
        hash = "sha256-hWJc5RxW6iK+W/rTxp2GUWKcm/2+oxbP5nVZ0EUSKHE=";
      })
      # https://gitlab.kitware.com/vtk/vtk/-/issues/19705
      (fetchpatch2 {
        url = "https://gitlab.kitware.com/vtk/vtk/-/commit/ce10dfe82ffa19c8108885625a6f8b3f980bed3b.diff";
        hash = "sha256-kyPM0whL4WeaV27sNM1fbbs5kwMYn+9E561HtvnwHRc=";
      })
      # https://gitlab.kitware.com/vtk/vtk/-/merge_requests/12262
      (fetchpatch2 {
        url = "https://gitlab.kitware.com/vtk/vtk/-/commit/c0e0f793e6adf740f5b1c91ac330afdbc2a03b72.diff";
        hash = "sha256-BinSv8sPqpAEcgkn8trnCPv2snR9MGcA8rkVflAhc5w=";
      })
    ];
  };
}
