{
  lib,
  stdenv,
  toPythonModule,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  scikit-build-core,
  nanobind,

  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config,

  # buildInputs
  dolfinx,

  # dependency
  numpy,
  cffi,
  mpi4py,
  petsc4py,
  slepc4py,
  adios2,
  kahip,
  fenics-ffcx,
  fenics-basix,
  fenics-ufl,

  # nativeCheckInputs
  scipy,
  matplotlib,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  mpiCheckPhaseHook,

  # custom options
  withParmetis ? false,

  # passthru.tests
  fenics-dolfinx,
  mpich,
}:

let
  fenicsPackages = petsc4py.petscPackages.overrideScope (
    final: prev: {
      slepc = final.callPackage slepc4py.override { };
      adios2 = final.callPackage adios2.override { };
      kahip = final.callPackage kahip.override { };
      dolfinx = final.callPackage dolfinx.override { inherit withParmetis; };
    }
  );
in
buildPythonPackage rec {
  inherit (dolfinx)
    version
    src
    ;
  pname = "fenics-dolfinx";
  pyproject = true;

  pythonRelaxDeps = [
    "cffi"
    "fenics-ufl"
  ];

  preConfigure = ''
    cd python
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    scikit-build-core
    nanobind
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    fenicsPackages.mpi
  ];

  buildInputs = [
    fenicsPackages.dolfinx
  ];

  dependencies = [
    numpy
    cffi
    fenics-basix
    fenics-ffcx
    fenics-ufl
    petsc4py
    fenicsPackages.slepc
    fenicsPackages.adios2
    fenicsPackages.kahip
    (mpi4py.override { inherit (fenicsPackages) mpi; })
  ];

  doCheck = true;

  nativeCheckInputs = [
    scipy
    matplotlib
    pytestCheckHook
    writableTmpDirAsHomeHook
    mpiCheckPhaseHook
  ];

  preCheck = ''
    rm -rf dolfinx
  '';

  pythonImportsCheck = [
    "dolfinx"
  ];

  disabledTests = [
    # require cffi<1.17
    "test_cffi_expression"
    "test_hexahedron_mesh"
    # https://github.com/FEniCS/dolfinx/issues/1104
    "test_cube_distance"
  ];

  passthru = {
    tests = {
      complex = fenics-dolfinx.override {
        petsc4py = petsc4py.override { scalarType = "complex"; };
      };
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      mpich = fenics-dolfinx.override {
        petsc4py = petsc4py.override { mpi = mpich; };
      };
    };
  };

  meta = {
    homepage = "https://fenicsproject.org";
    downloadPage = "https://github.com/fenics/dolfinx";
    description = "Computational environment of FEniCSx and implements the FEniCS Problem Solving Environment in C++ and Python";
    changelog = "https://github.com/fenics/dolfinx/releases/tag/${src.tag}";
    license = with lib.licenses; [
      bsd2
      lgpl3Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
