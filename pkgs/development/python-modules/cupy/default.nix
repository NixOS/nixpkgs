{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  autoAddDriverRunpath,
  writableTmpDirAsHomeHook,

  # dependencies
  numpy,
  cuda-pathfinder,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cupy";
  version = "14.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cupy";
    repo = "cupy";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-8jreEbQA24V7EAD87z3uFwlr3LPDoGRCvF5vbf2dKvI=";
  };

  patches = [
    # Let cupy_setup_build.py find static libraries (.a) from buildInputs.
    # By default, it looks for them in `$CUDA_PATH/lib{64,}`.
    ./link-static-libraries.patch

    # Fix test collection with pytest>=9
    # https://github.com/cupy/cupy/pull/10020
    (fetchpatch {
      name = "pytest-9-compat.patch";
      url = "https://github.com/cupy/cupy/commit/6f52f1541e0e047cdb84286793d6110567bce5c8.patch";
      hash = "sha256-D4VjOL0XO8gnfItGC/2MjuWYCJ7eNJYFn8jIyM+EojM=";
    })
  ];

  postPatch =
    # Inject absolute path to nvcc instead of relying on runtime discovery heuristics
    ''
      substituteInPlace cupy/_environment.py \
        --replace-fail \
          "nvcc_path = os.environ.get('NVCC', None)" \
          "return '${lib.getExe cudaPackages.cuda_nvcc}'"
    ''
    # Inject absolute path to CUDA libraries which get disovered at runtime
    + ''
      substituteInPlace cupy/_core/core.pyx \
        --replace-fail \
          "_cuda_include_dir = find_nvidia_header_directory('cudart')" \
          "_cuda_include_dir = '${lib.getInclude cudaPackages.cuda_cudart}/include'"

      substituteInPlace cupy/cuda/__init__.py \
        --replace-fail \
          "from cuda import pathfinder" \
          "from ctypes import CDLL" \
        --replace-fail \
          'pathfinder.load_nvidia_dynamic_lib("cufft")' \
          'CDLL("${lib.getLib cudaPackages.libcufft}/lib/libcufft.so")'

      substituteInPlace cupy/cuda/cufft.pyx \
        --replace-fail \
          "from cuda import pathfinder" \
          "from ctypes import CDLL" \
        --replace-fail \
          "loaded_dl = pathfinder.load_nvidia_dynamic_lib('cufft')" \
          "loaded_dl = CDLL('${lib.getLib cudaPackages.libcufft}/lib/libcufft.so')" \
        --replace-fail \
          "handle = loaded_dl._handle_uint" \
          "handle = loaded_dl._handle"

      substituteInPlace cupy_backends/cuda/api/_runtime_softlink.pxi \
        --replace-fail \
          "from cuda import pathfinder" \
          "from ctypes import CDLL" \
        --replace-fail \
          "loaded_dl = pathfinder.load_nvidia_dynamic_lib('cudart')" \
          "loaded_dl = CDLL('${lib.getLib cudaPackages.cuda_cudart}/lib/libcudart.so')" \
        --replace-fail \
          "handle = loaded_dl._handle_uint" \
          "handle = loaded_dl._handle"

      substituteInPlace cupy_backends/cuda/libs/_cnvrtc.pxi \
        --replace-fail \
          "from cuda import pathfinder" \
          "from ctypes import CDLL" \
        --replace-fail \
          "loaded_dl = pathfinder.load_nvidia_dynamic_lib('nvrtc')" \
          "loaded_dl = CDLL('${lib.getLib cudaPackages.cuda_nvrtc}/lib/libnvrtc.so')" \
        --replace-fail \
          "handle = loaded_dl._handle_uint" \
          "handle = loaded_dl._handle"

      substituteInPlace cupy/cuda/compiler.py \
        --replace-fail \
          "cudadevrt = get_cuda_path()" \
          "return '${lib.getOutput "static" cudaPackages.cuda_cudart}/lib/libcudadevrt.a'"
    '';

  env = {
    LDFLAGS = toString [
      # Fake libcuda.so (the real one is deployed impurely)
      "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"
    ];
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

  enableParallelBuilding = true;

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc

    writableTmpDirAsHomeHook # Needed for pythonImportsCheck
  ];

  buildInputs = with cudaPackages; [
    cuda_cudart # cuda.h, cuda_runtime.h, libcudart_static.a
    cuda_cuxxfilt # nv_decode.h
    cuda_nvrtc # nvrtc.h
    cuda_nvtx # nvToolsExt.h
    cuda_profiler_api # cuda_profiler_api.h
    libcublas # cublas_v2.h
    libcufft # cufft.h
    libcurand # curand.h
    libcusolver # cusolverDn.h
    libcusparse # cusparse.h
    libcusparse_lt # cusparseLt.h
    libcutensor # cutensor.h
    nccl # nccl.h

    (lib.getOutput "static" cuda_cuxxfilt) # libcufilt.a
  ];

  dependencies = [
    cuda-pathfinder
    numpy
  ];

  pythonImportsCheck = [
    "cupy"
    "cupy_backends"
    "cupyx"
  ];

  # Won't work with the GPU, whose drivers won't be accessible from the build sandbox
  doCheck = false;

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
    teams = [ lib.teams.cuda ];
  };
})
