{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  gfortran,
  cmake,
  ninja,
  mpi,
  libspatialindex,
  rtree,
}:

buildPythonPackage {
  inherit (pkgs.libsupermesh)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  build-system = [
    scikit-build-core
  ];

  nativeBuildInputs = [
    gfortran
    cmake
    ninja
    mpi
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libspatialindex
    gfortran.cc.lib
  ];

  dependencies = [
    rtree
  ];

  # Only build tests if not built by scikit-build-core
  doCheck = false;
}
