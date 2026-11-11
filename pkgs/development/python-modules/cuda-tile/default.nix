{
  lib,
  addDriverRunpath,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # nativeBuildInputs
  cmake,
  cudaPackages,

  # buildInputs
  dlpack,

  # tests
  cupy,
  llvm,
  numba-cuda,
  numpy,
  pytest-benchmark,
  pytest-env,
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,

  # passthru
  cuda-tile,
}:
let
  libCudaDir =
    # `cuda_compat` provides a newer `libcuda.so` in its `compat` directory
    if (cudaPackages.cuda_compat.meta.available or false) then
      "${cudaPackages.cuda_compat}/compat"
    # Else: the host driver library
    else
      "${addDriverRunpath.driverLink}/lib";

  # https://github.com/NVIDIA/cutile-python/blob/v1.7.0/cmake/FetchXLAHeaders.cmake#L5-L6
  xla = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    rev = "b6f37ab7767f428fd6f993de5e211643d47d4deb";
    hash = "sha256-U4e3k4nm9gB1x5hahXwycWSryBQuxIPmOzVf6kuahY0=";
  };
in
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cuda-tile";
  version = "1.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutile-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mO5VOusQg6wYzrvkD9SB74O6g5fOnyEdCIIKBkjC7s4=";
  };

  patches = [
    ./xla_ffi-include-python-first.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.0.0" "setuptools"
  ''
  # Otherwise fails to find libc
  # xla_ffi.cpp:(.text+0x308): undefined reference to `__stack_chk_fail'
  + ''
    substituteInPlace cext/CMakeLists.txt \
      --replace-fail \
        "target_link_libraries(_cext_shared _cext_static \''${Python_LIBRARIES} \''${asan_library})" \
        "target_link_libraries(_cext_shared _cext_static \''${Python_LIBRARIES} \''${asan_library} c)"
  ''
  # Don't build with -Werror: GCC 15 flags variables in cext/tile_kernel.cpp as set but not used
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'treat warnings as errors" OFF)' \
        'treat warnings as errors" ON)'
  ''
  # Get rid of the vendored broken logic for finding the CUDA toolkit
  + ''
    rm cmake/FindCUDAToolkit.cmake
  ''
  # Manually inject the library version
  + ''
    echo "${finalAttrs.version}" >src/cuda/tile/VERSION
  ''
  # `libcuda.so.1` is loaded by name, which the dynamic loader doesn't find outside of FHS dirs
  + ''
    substituteInPlace src/cuda/tile/_load_libcuda.py \
      --replace-fail \
        '_dll = CDLL("libcuda.so.1")' \
        '_dll = CDLL("${libCudaDir}/libcuda.so.1")'
  ''
  # Use tileiras from Nixpkgs instead of searching for it in /usr/local/cuda*, which is the last place cuTile looks
  # (after the nvidia-cuda-tileiras Python package, PATH, and $CUDA_HOME/bin).
  + lib.optionalString cudaPackages.cuda_tileiras.meta.available ''
    substituteInPlace src/cuda/tile/_compile.py \
      --replace-fail \
        "res = _find_file(_get_default_cuda_toolkit_paths(), [\"bin\"], [binary_name]," \
        "res = _find_file([\"${lib.getBin cudaPackages.cuda_tileiras}\"], [\"bin\"], [binary_name],"
  '';

  build-system = [
    setuptools
  ];

  env = {
    CUDA_TILE_CMAKE_DLPACK_PATH = dlpack;
    CUDA_TILE_CMAKE_XLA_PATH = xla;
  };

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    cudaPackages.cuda_cudart # cuda.h
    cudaPackages.libnvvm # nvvm.h (libnvvm itself is loaded at run time, by the experimental cuda.lang only)
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "cuda.tile" ];

  nativeCheckInputs = [
    cupy
    llvm # FileCheck, for the MLIR tests
    numba-cuda
    numpy
    pytest-benchmark
    pytest-env
    pytestCheckHook
    torch
    # cuTile fails to compile kernels if it cannot create its cache directory in $HOME
    writableTmpDirAsHomeHook
  ];

  # Run the benchmarks once as tests, without timing them
  pytestFlags = [ "--benchmark-disable" ];

  # The benchmarks look up their tuned configurations by GPU name, which they otherwise get from nvidia-smi
  preCheck = ''
    export CUDA_TILE_BENCHMARK_GPU_NAME="$(python -c 'import torch; print(torch.cuda.get_device_name(0))')"
  '';

  disabledTestPaths = [
    # Separate packages (task_scheduling, tile_preview, cuda-lang), not installed here; upstream's CI ignores them too
    "experimental"
  ];

  disabledTests = [
    # Deselected by upstream's CI too
    "int64_index"
    # These need more memory than a 24 GiB GPU has: a 65536x16384 layer norm, and float32 vector adds of 2^30 elements
    # (in each layout). Failed tests keep their tensors alive (through their tracebacks), so they also made later
    # benchmarks run out of memory.
    "64K-16K"
    "1G-1G-f32"
    "1G-1Mx1K-f32"
    "1G-8Mx128-f32"
    "1G-32Mx32-f32"
  ];

  # Tests require access to a physical GPU
  doCheck = false;

  passthru.gpuCheck = cuda-tile.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Programming model for writing parallel kernels for NVIDIA GPUs";
    homepage = "https://docs.nvidia.com/cuda/cutile-python/";
    downloadPage = "https://github.com/NVIDIA/cutile-python";
    changelog = "https://docs.nvidia.com/cuda/cutile-python/generated/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      prince213
    ];
    broken = !config.cudaSupport;
  };
})
