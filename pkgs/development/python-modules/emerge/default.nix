{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,

  cudaPackages,

  # build-system
  hatchling,

  # dependencies
  emsutil,
  gmsh,
  joblib,
  loguru,
  matplotlib,
  mkl,
  msgpack,
  msgpack-numpy,
  numba,
  numpy,
  psutil,
  pyvista,
  scipy,

  # optional-dependencies
  cupy,
  nvmath-python,
  ezdxf,
  pygerber,
  #scikit-umfpack,

  # tests
  callPackage,

  cudaSupport ? config.cudaSupport,
  withMkl ? stdenv.hostPlatform.isx86_64 && config.allowUnfree,
}:

let
  # NOTE:
  # `nvmath.bindings.cudss.AlgType` has been removed in newer versions of
  # `nvmath-python`, but `emerge` still uses it. See:
  #   - https://docs.nvidia.com/cuda/nvmath-python/latest/bindings/generated/nvmath.bindings.cudss.AlgType.html
  #   - https://docs.nvidia.com/cuda/nvmath-python/1.0.0/release-notes.html
  nvmath-python' = nvmath-python.overrideAttrs rec {
    version = "0.9.0";
    src = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "nvmath-python";
      tag = "v${version}";
      hash = "sha256-sIVvehCmkPvpPbHxhUPbKZ1cHnHTSlrgBHKSsHbUJPg=";
    };
    pythonRelaxDeps = [
      "cuda-core"
    ];
  };
in

buildPythonPackage (finalAttrs: {
  pname = "emerge";
  version = "2.8.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "EMerge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxJeSiHfYTY7mRll8cxJSpdciun+uw5V7FLTUKuHu28=";
  };

  postPatch = ''
    # TODO: get from pypi?
    # https://pypi.org/project/mkl
    sed -i '/mkl!=2024.0;/d' pyproject.toml
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    emsutil
    gmsh
    joblib
    loguru
    matplotlib
    msgpack
    msgpack-numpy
    numba
    numpy
    psutil
    pyvista
    scipy
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
    cudss = [
      cupy
      cudaPackages.libcudss
      nvmath-python'
    ];
    dxf = [
      ezdxf
    ];
    gerber = [
      pygerber
    ];
    umfpack = [
      #scikit-umfpack # TODO: package
    ];
  };

  pythonRelaxDeps = [
    "gmsh"
    "numpy"
  ];

  pythonImportsCheck = [
    "emerge"
  ];

  # upstream has no tests
  doCheck = false;

  passthru = {
    inherit
      cudaSupport
      ;

    tests = callPackage ./tests { };

    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v(2\\.[0-9].*)$" ];
    };
  };

  meta = {
    description = "Electromagnetic field computation program";
    homepage = "https://github.com/FennisRobert/EMerge";
    mainProgram = "emerge";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
