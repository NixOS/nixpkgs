{
  lib,
  config,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchPypi,

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
  boost,
  ocl-icd,
  opencl-headers,

  # dependencies
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

buildPythonPackage rec {
  inherit (pkgs.lightgbm)
    pname
    version
    patches
    ;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yxxZcg61aTicC6dNFPUjUbVzr0ifIwAyocnzFPi6t/4=";
  };

  # Patch dll search path to fix proper discovery of lib_lightgbm.so
  #   Exception: Cannot find lightgbm library file in following paths:
  # /nix/store/...-python3.13-lightgbm-4.6.0/lib/python3.13/site-packages/lib_lightgbm.so
  # /nix/store/...-python3.13-lightgbm-4.6.0/lib/python3.13/site-packages/lightgbm/bin/lib_lightgbm.so
  # /nix/store/...-python3.13-lightgbm-4.6.0/lib/python3.13/site-packages/lightgbm/lib/lib_lightgbm.so
  postPatch = ''
    substituteInPlace lightgbm/libpath.py \
      --replace-fail \
        'curr_path.parents[0] / "lib",' \
        'curr_path.parents[1] / "lib",'
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
      boost
      ocl-icd
      opencl-headers
    ])
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cudart
    ];

  dependencies = [
    numpy
    scipy
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_GPU" gpuSupport)
    (lib.cmakeBool "USE_CUDA" cudaSupport)
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

  # No python tests
  doCheck = false;

  pythonImportsCheck = [ "lightgbm" ];

  meta = {
    description = "Fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = "https://github.com/Microsoft/LightGBM";
    changelog = "https://github.com/microsoft/LightGBM/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
  };
}
