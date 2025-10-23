{
  lib,
  newScope,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  python,
  pax-utils,

  # build-system
  setuptools,
  cython,
  pybind11,

  # dependencies
  decorator,
  cachetools,
  mpi4py,
  fenics-ufl,
  firedrake-fiat,
  h5py,
  libsupermesh,
  loopy,
  petsc4py,
  petsctools,
  numpy,
  packaging,
  pkgconfig,
  progress,
  pyadjoint-ad,
  pycparser,
  pytools,
  requests,
  rtree,
  scipy,
  sympy,
  islpy,
  vtk,
  matplotlib,
  immutabledict,

  # tests
  pytest,
  mpi-pytest,
  mpiCheckPhaseHook,
  writableTmpDirAsHomeHook,

  # passthru
  firedrake,
  mpich,
  nix-update-script,
}:
let
  firedrakePackages = lib.makeScope newScope (self: {
    inherit (petsc4py.petscPackages) mpi hdf5;
    mpi4py = self.callPackage mpi4py.override { };
    h5py = self.callPackage h5py.override { };
    mpi-pytest = self.callPackage mpi-pytest.override { };
  });
in
buildPythonPackage rec {
  pname = "firedrake";
  version = "2025.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "firedrake";
    tag = version;
    hash = "sha256-paZNs6T9v7TNSdc8YJTjNcQvGrPg/Sy9K27/aUxNu5w=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/firedrakeproject/firedrake/pull/4632/commits/717ae8a62e19e0cc91419c12ca14170d252b2bb9.patch?full_index=1";
      hash = "sha256-XHIcXmfh/brlQkrM4FTRvTrOovLvBN5mBrqZpZewTnc=";
    })
  ];

  # relax build-dependency petsc4py
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
      "petsc4py==3.24.0" "petsc4py"
  '';

  pythonRelaxDeps = [
    "decorator"
  ];

  build-system = [
    cython
    libsupermesh
    firedrakePackages.mpi4py
    numpy
    pkgconfig
    pybind11
    setuptools
    petsc4py
    rtree
  ];

  nativeBuildInputs = [
    firedrakePackages.mpi
  ];

  dependencies = [
    decorator
    cachetools
    firedrakePackages.mpi4py
    fenics-ufl
    firedrake-fiat
    firedrakePackages.h5py
    libsupermesh
    loopy
    petsc4py
    petsctools
    numpy
    packaging
    pkgconfig
    progress
    pyadjoint-ad
    pycparser
    pytools
    requests
    rtree
    scipy
    sympy
    vtk
    # required by script spydump
    matplotlib
    # required by pyop2
    immutabledict
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    islpy
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath ${libsupermesh}/${python.sitePackages}/libsupermesh/lib \
      $out/${python.sitePackages}/firedrake/cython/supermeshimpl.cpython-*-darwin.so
  '';

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "firedrake" ];

  nativeCheckInputs = [
    pytest
    firedrakePackages.mpi-pytest
    mpiCheckPhaseHook
    writableTmpDirAsHomeHook
  ];

  # run official smoke tests
  checkPhase = ''
    runHook preCheck

    $out/bin/firedrake-check

    runHook postCheck
  '';

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "([0-9.]+)"
      ];
    };

    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      mpich = firedrake.override {
        petsc4py = petsc4py.override { mpi = mpich; };
      };
    };
  };

  meta = {
    homepage = "https://www.firedrakeproject.org";
    downloadPage = "https://github.com/firedrakeproject/firedrake";
    description = "Automated Finite Element System";
    license = with lib.licenses; [
      bsd3
      lgpl3Plus
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
