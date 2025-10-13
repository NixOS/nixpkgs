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
  matplotlib,

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
  version = "2025.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "firedrake";
    tag = version;
    hash = "sha256-bAGmXoHPAdMYJMMQYVq98LYro1Vd+o9pfvXC3BsQUf0=";
  };

  postPatch =
    # relax build-dependency petsc4py
    ''
      substituteInPlace pyproject.toml --replace-fail \
        "petsc4py==3.23.4" "petsc4py"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace firedrake/petsc.py --replace-fail \
        'program = ["ldd"]' \
        'program = ["${lib.getExe' pax-utils "lddtree"}"]'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace firedrake/petsc.py --replace-fail \
        'program = ["otool"' \
        'program = ["${lib.getExe' stdenv.cc.bintools.bintools "otool"}"'
    '';

  pythonRelaxDeps = [
    "decorator"
    "slepc4py"
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
    # required by script spydump
    matplotlib
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

  # These scripts are used by official sdist/editable_wheel only
  postInstall = ''
    rm $out/bin/firedrake-{check,status,run-split-tests}
  '';

  preCheck = ''
    rm -rf firedrake pyop2 tinyasm tsfc
  '';

  # run official smoke tests
  checkPhase = ''
    runHook preCheck

    make check

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
