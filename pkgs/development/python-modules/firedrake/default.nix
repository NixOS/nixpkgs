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

  # passthru.tests
  firedrake,
  mpich,
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
  version = "2025.4.0.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "firedrake";
    tag = version;
    hash = "sha256-wQOS4v/YkIwXdQq6JMvRbmyhnzvx6wj0O6aszNa5ZMw=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/firedrakeproject/firedrake/commit/b358e33ab12b3c4bc3819c9c6e9ed0930082b750.patch?full_index=1";
      hash = "sha256-y00GB8njhmHgtAVvlv8ImsJe+hMCU1QFtbB8llEhv/I=";
    })
  ];

  postPatch =
    ''
      # relax build-dependency petsc4py
      substituteInPlace pyproject.toml --replace-fail \
        "petsc4py==3.23.0" "petsc4py"

      # These scripts are used by official source distribution only,
      # and do not make sense in our binary distribution.
      sed -i '/firedrake-\(check\|status\|run-split-tests\)/d' pyproject.toml
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

  dependencies =
    [
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
    ++ pytools.optional-dependencies.siphash
    ++ lib.optional stdenv.hostPlatform.isDarwin islpy;

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
