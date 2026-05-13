{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  cudaPackages,
  symlinkJoin,
  addDriverRunpath,

  # dependencies
  numpy,
  cuda-pathfinder,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

let
  shouldUsePkg = lib.mapNullable (pkg: if pkg.meta.available or true then pkg else null);

  # some packages are not available on all platforms
  cuda_nvprof = shouldUsePkg (cudaPackages.nvprof or null);
  libcutensor = shouldUsePkg (cudaPackages.libcutensor or null);
  nccl = shouldUsePkg (cudaPackages.nccl or null);

  outpaths = lib.filter (outpath: outpath != null) (
    with cudaPackages;
    [
      cuda_cccl # <nv/target>
      cuda_cudart
      cuda_nvcc # <crt/host_defines.h>
      cuda_nvprof
      cuda_nvrtc
      cuda_nvtx
      cuda_profiler_api
      libcublas
      libcufft
      libcurand
      libcusolver
      libcusparse
      libcusparse_lt # cusparseLt.h
    ]
  );
  cudatoolkit-joined = symlinkJoin {
    name = "cudatoolkit-joined-${cudaPackages.cudaMajorMinorVersion}";
    paths =
      outpaths ++ lib.concatMap (outpath: lib.map (output: outpath.${output}) outpath.outputs) outpaths;
  };
in
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cupy";
  version = "14.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cupy";
    repo = "cupy";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-TaEJ0BveUCXCRrNq9L49Tfbu0334+cANcVm5qnSOE1Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "Cython>=3.1,<3.2" \
        "Cython"
  '';

  env = {
    LDFLAGS = toString [
      # Fake libcuda.so (the real one is deployed impurely)
      "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"
    ];
    # NVCC = "${lib.getExe cudaPackages.cuda_nvcc}"; # FIXME: splicing/buildPackages
    CUDA_PATH = "${cudatoolkit-joined}";
  };

  # See https://docs.cupy.dev/en/v10.2.0/reference/environment.html. Setting both
  # CUPY_NUM_BUILD_JOBS and CUPY_NUM_NVCC_THREADS to NIX_BUILD_CORES results in
  # a small amount of thrashing but it turns out there are a large number of
  # very short builds and a few extremely long ones, so setting both ends up
  # working nicely in practice.
  preConfigure = ''
    export CUPY_NUM_BUILD_JOBS="$NIX_BUILD_CORES"
    export CUPY_NUM_NVCC_THREADS="$NIX_BUILD_CORES"
  '';

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    addDriverRunpath
    cudatoolkit-joined
  ];

  buildInputs = [
    cudatoolkit-joined
    libcutensor
    nccl
  ];

  dependencies = [
    cuda-pathfinder
    numpy
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  # Won't work with the GPU, whose drivers won't be accessible from the build
  # sandbox
  doCheck = false;

  postFixup = ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addDriverRunpath "$lib"
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "NumPy-compatible matrix library accelerated by CUDA";
    homepage = "https://cupy.chainer.org/";
    changelog = "https://github.com/cupy/cupy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
