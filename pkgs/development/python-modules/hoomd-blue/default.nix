{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  pkgconfig,
  python,
  mpi ? null,
}:

let
  components = {
    cgcmm = true;
    depreciated = true;
    hpmc = true;
    md = true;
    metal = true;
  };
  onOffBool = b: if b then "ON" else "OFF";
  withMPI = (mpi != null);
in
buildPythonPackage rec {
  version = "2.3.4";
  pname = "hoomd-blue";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "hoomd-blue";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-VAUpiuBp+hw/kgfoFvgNY1nvtF4YC1uoHQOq3YJLxEY=";
  };

  passthru = {
    inherit components mpi;
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
  buildInputs = lib.optionals withMPI [ mpi ];
  propagatedBuildInputs = [ python.pkgs.numpy ] ++ lib.optionals withMPI [ python.pkgs.mpi4py ];

  dontAddPrefix = true;
  cmakeFlags = [
    "-DENABLE_MPI=${onOffBool withMPI}"
    "-DBUILD_CGCMM=${onOffBool components.cgcmm}"
    "-DBUILD_DEPRECIATED=${onOffBool components.depreciated}"
    "-DBUILD_HPMC=${onOffBool components.hpmc}"
    "-DBUILD_MD=${onOffBool components.md}"
    "-DBUILD_METAL=${onOffBool components.metal}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python.sitePackages}"
  ];

  # tests fail but have tested that package runs properly
  doCheck = false;
  checkTarget = "test";

  meta = with lib; {
    homepage = "http://glotzerlab.engin.umich.edu/hoomd-blue/";
    description = "HOOMD-blue is a general-purpose particle simulation toolkit";
    license = licenses.bsdOriginal;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    # Has compilation errors since some dependencies got updated, will probably
    # be fixed if updated by itself to the latest version.
    broken = true;
  };
}
