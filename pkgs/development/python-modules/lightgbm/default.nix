{ lib
, config
, stdenv
, buildPythonPackage
, fetchPypi

# build-system
, cmake
, ninja
, pathspec
, pyproject-metadata
, scikit-build-core

# dependencies
, llvmPackages
, numpy
, scipy
, pythonOlder

# optionals
, cffi
, dask
, pandas
, pyarrow
, scikit-learn

# optionals: gpu
, boost
, ocl-icd
, opencl-headers
, gpuSupport ? stdenv.isLinux && !cudaSupport
, cudaSupport ? config.cudaSupport
, cudaPackages
}:

assert gpuSupport -> cudaSupport != true;
assert cudaSupport -> gpuSupport != true;

buildPythonPackage rec {
  pname = "lightgbm";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ik0FHfKrIhiZihb3cS6EPunpbYsJ/7/MGFM9oSfg2gI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pathspec
    pyproject-metadata
    scikit-build-core
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  dontUseCmakeConfigure = true;

  buildInputs = (lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ]) ++ (lib.optionals gpuSupport [
    boost
    ocl-icd
    opencl-headers
  ]) ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pypaBuildFlags = lib.optionals gpuSupport [
    "--config-setting=cmake.define.USE_GPU=ON"
  ] ++ lib.optionals cudaSupport [
    "--config-setting=cmake.define.USE_CUDA=ON"
  ];

  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  passthru.optional-dependencies = {
    arrow = [
      cffi
      pyarrow
    ];
    dask = [
      dask
      pandas
    ] ++ dask.optional-dependencies.array
      ++ dask.optional-dependencies.dataframe
      ++ dask.optional-dependencies.distributed;
    pandas = [
      pandas
    ];
    scikit-learn = [
      scikit-learn
    ];
  };

  # The pypi package doesn't distribute the tests from the GitHub
  # repository. It contains c++ tests which don't seem to wired up to
  # `make check`.
  doCheck = false;

  pythonImportsCheck = [
    "lightgbm"
  ];

  meta = {
    description = "A fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = "https://github.com/Microsoft/LightGBM";
    changelog = "https://github.com/microsoft/LightGBM/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
  };
}
