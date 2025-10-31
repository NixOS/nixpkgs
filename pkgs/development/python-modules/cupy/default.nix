{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  fastrlock,
  numpy,
  pytestCheckHook,
  mock,
  setuptools,
  cudaPackages,
  addDriverRunpath,
  symlinkJoin,
}:

let
  inherit (cudaPackages) cudnn;

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
      # NOTE: libcusparse_lt is too new for CuPy, so we must do without.
      # libcusparse_lt
    ]
  );
  cudatoolkit-joined = symlinkJoin {
    name = "cudatoolkit-joined-${cudaPackages.cudaMajorMinorVersion}";
    paths =
      outpaths ++ lib.concatMap (outpath: lib.map (output: outpath.${output}) outpath.outputs) outpaths;
  };
in
buildPythonPackage rec {
  pname = "cupy";
  version = "13.6.0";
  pyproject = true;

  stdenv = cudaPackages.backendStdenv;

  src = fetchFromGitHub {
    owner = "cupy";
    repo = "cupy";
    tag = "v${version}";
    hash = "sha256-nU3VL0MSCN+mI5m7C5sKAjBSL6ybM6YAk5lJiIDY0ck=";
    fetchSubmodules = true;
  };

  env.LDFLAGS = toString [
    # Fake libcuda.so (the real one is deployed impurely)
    "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"
  ];

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
    fastrlock
    setuptools
  ];

  nativeBuildInputs = [
    addDriverRunpath
    cudatoolkit-joined
  ];

  buildInputs = [
    cudatoolkit-joined
    cudnn
    libcutensor
    nccl
  ];

  # NVCC = "${lib.getExe cudaPackages.cuda_nvcc}"; # FIXME: splicing/buildPackages
  CUDA_PATH = "${cudatoolkit-joined}";

  dependencies = [
    fastrlock
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
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

  meta = with lib; {
    description = "NumPy-compatible matrix library accelerated by CUDA";
    homepage = "https://cupy.chainer.org/";
    changelog = "https://github.com/cupy/cupy/releases/tag/${src.tag}";
    license = licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
