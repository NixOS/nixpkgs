{
  lib,
  config,
  stdenv,
  pkgs,
  buildPythonPackage,

  # build-system
  scikit-build-core,

  # nativeBuildInputs
  cmake,
  ninja,
  pathspec,
  pyproject-metadata,
  writableTmpDirAsHomeHook,

  # buildInputs
  llvmPackages,
  boost187,
  ocl-icd,
  opencl-headers,

  # dependencies
  narwhals,
  numpy,
  scipy,

  # optional-dependencies
  cffi,
  dask,
  pandas,
  pyarrow,
  scikit-learn,

  # optionals: gpu
  gpuSupport ? stdenv.hostPlatform.isLinux && !cudaSupport,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

assert gpuSupport -> !cudaSupport;
assert cudaSupport -> !gpuSupport;

let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
buildPythonPackage.override { stdenv = effectiveStdenv; } (finalAttrs: {
  inherit (pkgs.lightgbm)
    pname
    version
    patches
    src
    ;
  pyproject = true;

  # These need to be in the root for the build to work.
  # The tarballs on PyPi are structured the same.
  postUnpack = ''
    mv source/python-package/{pyproject.toml,README.rst} source/
  '';

  build-system = [
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pathspec
    pyproject-metadata
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  dontUseCmakeConfigure = true;

  buildInputs =
    (lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ])
    ++ (lib.optionals gpuSupport [
      boost187
      ocl-icd
      opencl-headers
    ])
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cudart
      cudaPackages.nccl
    ];

  dependencies = [
    narwhals
    numpy
    scipy
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_GPU" gpuSupport)
    (lib.cmakeBool "USE_CUDA" cudaSupport)
    # Set in pyproject.toml for `cmake.args` in `[tool.scikit-build]`,
    # but not set by our hooks.
    (lib.cmakeBool "__BUILD_FOR_PYTHON" true)
  ]
  ++ lib.optionals cudaSupport [
    # build fails otherwise
    (lib.cmakeFeature "CMAKE_CUDA_STANDARD" "14")

    # needed to find nccl
    (lib.cmakeBool "BUILD_WITH_SHARED_NCCL" true)
    (lib.cmakeFeature "NCCL_ROOT" "${lib.getLib cudaPackages.nccl}")
  ];

  optional-dependencies = {
    arrow = [
      cffi
      pyarrow
    ];
    dask = [
      dask
      pandas
    ]
    ++ dask.optional-dependencies.array
    ++ dask.optional-dependencies.dataframe
    ++ dask.optional-dependencies.distributed;
    pandas = [ pandas ];
    scikit-learn = [ scikit-learn ];
  };

  pythonImportsCheck = [ "lightgbm" ];

  meta = {
    description = "Fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = "https://github.com/lightgbm-org/LightGBM";
    changelog = "https://github.com/lightgbm-org/LightGBM/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      flokli
      teh
    ];
  };
})
