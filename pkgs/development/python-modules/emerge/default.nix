{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,

  cudaPackages,

  # dependencies
  emsutil,
  emerge-aasds,
  gmsh,
  joblib,
  loguru,
  matplotlib,
  mkl,
  msgpack,
  msgpack-numpy,
  numpy,
  psutil,
  pyvista,
  scipy,
  sparta-solver,

  # optional-dependencies
  corvid-solver,
  cupy,
  emcad,
  ezdxf,
  nvmath-python,
  pygerber,
  scikit-umfpack,

  # tests
  callPackage,
  pytestCheckHook,

  cudaSupport ? config.cudaSupport,
  withMkl ? stdenv.hostPlatform.isx86_64 && config.allowUnfree,
  fullTestSuite ? false,
  emerge,
}:

buildPythonPackage (finalAttrs: {
  pname = "emerge";
  version = "3.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "EMerge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XdcXRJYPWLIdsUUqkbZuIlae8QsgNHYZx5tPng0L6Z4=";
  };

  cargoRoot = "emr";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-NL8P73B9rjZ4X3KvvRq+1evRIu56vRYuuGIBMa1WrPs=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    emsutil
    gmsh
    joblib
    loguru
    matplotlib
    msgpack
    msgpack-numpy
    numpy
    psutil
    pyvista
    scipy
    sparta-solver
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    emerge-aasds
  ]
  ++ lib.optionals cudaSupport finalAttrs.passthru.optional-dependencies.cudss;

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  buildInputs =
    lib.optionals withMkl [
      mkl
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.libcudss
    ];

  optional-dependencies = {
    cad = [
      emcad
      pygerber
    ];
    corvid = [
      corvid-solver
    ];
    cudss = [
      cupy
      cudaPackages.libcudss
      nvmath-python
    ];
    dxf = [
      ezdxf
    ];
    umfpack = [
      scikit-umfpack
    ];
  };

  pythonRelaxDeps = [
    "gmsh"
    "numpy"
  ];

  pythonRemoveDeps = [
    "mkl"
  ];

  pythonImportsCheck = [
    "emerge"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.optionals fullTestSuite [
    scikit-umfpack
  ]
  ++ lib.optionals (fullTestSuite && stdenv.hostPlatform.isDarwin) [
    # pyvista runs `pgrep -qx Finder` on Darwin to detect headless/GUI sessions
    (writeShellScriptBin "pgrep" "exit 1")
  ];

  # Running the full test suite takes ~4 minutes; moved to passthru.tests.full
  pytestFlags = lib.optionals (!fullTestSuite) [
    "--collect-only"
  ];

  disabledTests = lib.optionals fullTestSuite [
    # requires unfree `mkl`
    "test_pardiso_non_symmetric_csc"
    # AASDS parallel frequency sweep consumes >10 GB RAM, exceeding runner memory
    "test_wg1"
    "test_wg2"
  ];

  # Cocoa VTK requires WindowServer / GPU access for OpenGL context creation
  __noChroot = fullTestSuite && stdenv.hostPlatform.isDarwin;

  passthru = {
    inherit cudaSupport;

    tests = (callPackage ./tests { }) // {
      full = emerge.override { fullTestSuite = true; };
    };
  };

  meta = {
    description = "Electromagnetic field computation program";
    homepage = "https://github.com/FennisRobert/EMerge";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
