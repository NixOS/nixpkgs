{ lib
, stdenv
, qtModule
, qtbase
, qtquick3d
, qtdeclarative
, qtwayland
, wayland
, wayland-scanner
, pkg-config
, libdrm
, pkgsBuildHost
, pkgsBuildBuild
}:

qtModule {
  pname = "qtwayland";
  propagatedBuildInputs = [ qtbase ];
  buildInputs = [ (lib.getLib wayland) libdrm qtdeclarative ];
  nativeBuildInputs = [ pkg-config wayland-scanner ];
}

