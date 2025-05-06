{
  lib,
  stdenv,
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
  spdlog,
  pugixml,
  boost,

  # dependency
  numpy,
  cffi,
  setuptools,
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
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  mpiCheckPhaseHook,
  withParmetis ? false,

  # passthru.tests
  fenics-dolfinx,
  mpich,
}:
assert petsc4py.mpiSupport;
let
  fenicsPackages = petsc4py.petscPackages.overrideScope (
    final: prev: {
      mpi4py = mpi4py.override { inherit (final) mpi; };
      slepc = final.callPackage slepc4py.override { };
      adios2 = final.callPackage adios2.override { hdf5-mpi = final.hdf5; };
      kahip = final.callPackage kahip.override { };
    }
  );
  dolfinx = stdenv.mkDerivation (finalAttrs: {
    version = "0.9.0.post1";
    pname = "dolfinx";

    src = fetchFromGitHub {
      owner = "fenics";
      repo = "dolfinx";
      tag = "v${finalAttrs.version}";
      hash = "sha256-4IIx7vUZeDwOGVdyC2PBvfhVjrmGZeVQKAwgDYScbY0=";
    };

    preConfigure = "cd cpp";

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      spdlog
      pugixml
      boost
      fenics-basix
      fenics-ffcx
      petsc4py
      fenicsPackages.mpi
      fenicsPackages.scotch
      fenicsPackages.hdf5
      fenicsPackages.slepc
      fenicsPackages.kahip
      fenicsPackages.adios2
    ] ++ lib.optional withParmetis fenicsPackages.parmetis;

    cmakeFlags = [
      (lib.cmakeBool "DOLFINX_ENABLE_ADIOS2" true)
      (lib.cmakeBool "DOLFINX_ENABLE_PETSC" true)
      (lib.cmakeBool "DOLFIN_ENABLE_PARMETIS" withParmetis)
      (lib.cmakeBool "DOLFINX_ENABLE_SCOTCH" true)
      (lib.cmakeBool "DOLFINX_ENABLE_SLEPC" true)
      (lib.cmakeBool "DOLFINX_ENABLE_KAHIP" true)
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    ];

    meta = {
      homepage = "https://fenicsproject.org";
      downloadPage = "https://github.com/fenics/dolfinx";
      description = "Computational environment of FEniCSx and implements the FEniCS Problem Solving Environment in C++ and Python";
      changelog = "https://github.com/fenics/dolfinx/releases/tag/${finalAttrs.src.tag}";
      license = with lib.licenses; [
        bsd2
        lgpl3Plus
      ];
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ qbisi ];
    };
  });
in
buildPythonPackage rec {
  inherit (dolfinx)
    version
    src
    meta
    ;
  pname = "fenics-dolfinx";
  pyproject = true;

  pythonRelaxDeps = [
    "cffi"
    "fenics-ufl"
  ];

  preConfigure = "cd python";

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
    dolfinx
    spdlog
    pugixml
    boost
    fenicsPackages.hdf5
  ];

  dependencies = [
    numpy
    cffi
    setuptools
    fenics-basix
    fenics-ffcx
    fenics-ufl
    petsc4py
    fenicsPackages.mpi4py
    fenicsPackages.slepc
    fenicsPackages.adios2
    fenicsPackages.kahip
  ];

  doCheck = true;

  nativeCheckInputs = [
    scipy
    matplotlib
    pytest-xdist
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
    # require legacy cffi
    "test_cffi_expression"
    "test_hexahedron_mesh"
  ];

  passthru = {
    tests =
      {
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
}
