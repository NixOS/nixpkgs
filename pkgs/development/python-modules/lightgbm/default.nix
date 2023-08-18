{ lib
, config
, stdenv
, buildPythonPackage
, fetchPypi
, cmake
, ninja
, dask
, numpy
, pandas
, pathspec
, pyproject-metadata
, scikit-build-core
, scikit-learn
, scipy
, llvmPackages ? null
, pythonOlder
, ocl-icd
, opencl-headers
, boost
, gpuSupport ? stdenv.isLinux && !cudaSupport
, cudaSupport ? config.cudaSupport or false
, cudaPackages ? { }
, symlinkJoin
}:
let
  cuda-common-redist = with cudaPackages; [
    cuda_cudart
  ];
  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaPackages.cudaVersion}";
    paths = with cudaPackages; [
      cuda_nvcc
    ] ++ cuda-common-redist;
  };
  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaPackages.cudaVersion}";
    paths = cuda-common-redist;
  };
in

assert gpuSupport -> !cudaSupport;
assert cudaSupport -> !gpuSupport;

buildPythonPackage rec {
  pname = "lightgbm";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A9GzkDqlHNml45ZZQSNvKnv1pp16dgWdv2j9m0/JLY8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pathspec
    pyproject-metadata
    scikit-build-core
  ] ++ lib.optionals cudaSupport [
    cuda-native-redist
  ];

  dontUseCmakeConfigure = true;

  buildInputs = (lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ]) ++ (lib.optionals gpuSupport [
    boost
    ocl-icd
    opencl-headers
  ]) ++ lib.optionals cudaSupport [
    cuda-redist
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pipBuildFlags = lib.optionals gpuSupport [
    "--config-settings=cmake.define.USE_GPU=ON"
  ] ++ lib.optionals cudaSupport [
    "--config-settings=cmake.define.USE_CUDA=ON"
  ];

  passthru.optional-dependencies = {
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

  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

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
    maintainers = with lib.maintainers; [ teh natsukium ];
  };
}
