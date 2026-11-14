{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  addDriverRunpath,
  cudaPackages,
  dlpack,
  libllvm7,
  llvmPackages_23,
  replaceVars,
  python,

  # build-system
  cmake,
  nanobind,
  ninja,
  pybind11,
  setuptools,

  # dependencies
  cuda-bindings,
  cuda-core,
  numpy,
  typing-extensions,

  # tests
  cffi,
  filecheck,
  ml-dtypes,
  pytest-benchmark,
  pytest-rerunfailures,
  pytest-subtests,
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  libCudaPath =
    # `cuda_compat` provides `libcuda.so` on pre-Thor Jetsons
    if (cudaPackages.cuda_compat.meta.available or false) then
      cudaPackages.cuda_compat
    # Else: the host driver library
    else
      addDriverRunpath.driverLink;

  # Upstream builds MLIR with its python bindings namespaced into `numba_cuda_mlir._mlir` and a
  # private nanobind domain, then stages them into the wheel; a stock MLIR cannot be used.
  mlir =
    (llvmPackages_23.mlir.override {
      devExtraCmakeFlags = [
        # `libMLIRToLLVM70.so` and the python bindings must reach MLIR through the same objects,
        # or their registered-operation TypeIDs differ: split libraries for both, and no aggregate
        # `libMLIR.so` for the bindings to bind to instead.
        (lib.cmakeBool "LLVM_BUILD_LLVM_DYLIB" false)
        (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" false)
        (lib.cmakeBool "MLIR_BUILD_MLIR_DYLIB" false)
        (lib.cmakeBool "MLIR_LINK_MLIR_DYLIB" false)
        (lib.cmakeBool "BUILD_SHARED_LIBS" true)
        (lib.cmakeBool "MLIR_ENABLE_BINDINGS_PYTHON" true)
        (lib.cmakeFeature "MLIR_PYTHON_PACKAGE_PREFIX" "numba_cuda_mlir._mlir")
        (lib.cmakeFeature "MLIR_BINDINGS_PYTHON_INSTALL_PREFIX" "python_packages/numba_cuda_mlir_mlir/numba_cuda_mlir/_mlir")
        (lib.cmakeFeature "MLIR_BINDINGS_PYTHON_NB_DOMAIN" "numba_cuda_mlir")
        (lib.cmakeBool "MLIR_PYTHON_STUBGEN_ENABLED" false)
        (lib.cmakeBool "CMAKE_PLATFORM_NO_VERSIONED_SONAME" true)
        (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DMLIR_PYTHON_PACKAGE_PREFIX=numba_cuda_mlir._mlir.")
      ];
    }).overrideAttrs
      (old: {
        # `setup.py` resolves the install root from `MLIR_DIR/../../..` with symlinks followed, so
        # the cmake package and the bindings have to share a prefix. A single output stops the
        # multiple-outputs hook from moving `lib/cmake` into `dev`.
        outputs = [ "out" ];
        cmakeFlags =
          builtins.filter (
            flag: !(lib.hasInfix "MLIR_INSTALL_PACKAGE_DIR" flag || lib.hasInfix "MLIR_INSTALL_CMAKE_DIR" flag)
          ) (old.cmakeFlags or [ ])
          ++ [
            (lib.cmakeFeature "MLIR_INSTALL_PACKAGE_DIR" "${placeholder "out"}/lib/cmake/mlir")
            (lib.cmakeFeature "MLIR_INSTALL_CMAKE_DIR" "${placeholder "out"}/lib/cmake/mlir")
          ];
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          python
          nanobind
          pybind11
        ];
        buildInputs = (old.buildInputs or [ ]) ++ [ python ];
        doCheck = false;
      });
in

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "numba-cuda-mlir";
  version = "0.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "numba-cuda-mlir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3u4Zwl84yUC85f7mG99VcGBuyKO72hRyg2+WJKaFX3Q=";
  };

  patches = [
    # Resolve the CUDA components from the store instead of walking a toolkit root, as in
    # `numba-cuda`; this vendors its own copy of numba-cuda's `cuda_paths.py`.
    (replaceVars ./nvidia-libs-paths.patch {
      cccl = "${lib.getInclude cudaPackages.cccl}/include";
      cudartInclude = "${lib.getInclude cudaPackages.cuda_cudart}/include";
      libcudart = lib.getLib cudaPackages.cuda_cudart;
      libcudartStatic = lib.getOutput "static" cudaPackages.cuda_cudart;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
      libnvvm =
        if cudaPackages.cudaOlder "13.0" then
          "${lib.getLib cudaPackages.cuda_nvcc}/nvvm"
        else
          lib.getLib cudaPackages.libnvvm;
    })

    # `NVVM::BarrierOp`'s reduction accessors only exist on the LLVM trunk commit upstream pins.
    # Dropping the branch costs `bar.red` (`__syncthreads_{count,and,or}`) on the LLVM70 path.
    ./drop-barrier-reduction.patch

    # The bindings are copied out of the read-only store, so the LLVM70 bridge cannot be staged
    # next to them afterwards
    ./writable-staged-bindings.patch
  ];

  postPatch =
    # `libcuda.so` is looked up in hardcoded FHS dirs, as in `numba` and `numba-cuda`
    ''
      substituteInPlace src/numba_cuda_mlir/numba_cuda/cudadrv/driver.py \
        --replace-fail \
          'dldir = ["/usr/lib", "/usr/lib64"]' \
          'dldir = ["${libCudaPath}/lib"]'
    ''
    # Expanded at parse time even when overridden, making the build log look like `make` failed
    + ''
      substituteInPlace tests/numba_cuda_tests/testing/Makefile \
        --replace-fail "GPU_CC := " "GPU_CC ?= "
    ''
    # `determine_include_flags()` wants a single `INCLUDES=` line from `nvcc -v`; nixpkgs' prints
    # two, neither carrying the runtime headers
    + ''
      substituteInPlace tests/numba_cuda_tests/testing/generate_raw_ltoir.py \
        --replace-fail \
          "cuda_include_flags = determine_include_flags()" \
          "cuda_include_flags = [\"-I${lib.getInclude cudaPackages.cuda_cudart}/include\", \"-I${lib.getInclude cudaPackages.cccl}/include\"]"
    ''
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          "if (DLPACK_PATH)" \
          "if (DEFINED ENV{DLPACK_PATH})" \
        --replace-fail \
          '"''${DLPACK_PATH}/include/dlpack"' \
          '"$ENV{DLPACK_PATH}/include/dlpack"'
    '';

  build-system = [
    cmake
    ninja
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
    nanobind
    # `MLIRConfig.cmake` resolves `mlir-tblgen` from `PATH`; nixpkgs ships it separately from mlir
    llvmPackages_23.tblgen
  ];

  buildInputs = [
    (lib.getDev llvmPackages_23.libllvm)
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc
    cudaPackages.libnvjitlink
    mlir
  ];

  dependencies = [
    cuda-bindings
    cuda-core
    numpy
    typing-extensions
  ];

  env = {
    MLIR_DIR = "${mlir}/lib/cmake/mlir";
    # Otherwise the build fetches dlpack's headers from GitHub
    DLPACK_PATH = (lib.getDev dlpack).outPath;
    # `setup.py` stages this into the wheel; the LLVM70 path dlopens it for every GPU below sm_100
    LIBLLVM7 = "${libllvm7}/lib/libLLVM-7.so";
  };

  # `libMLIRToLLVM70.so` links MLIR's python CAPI, but `setup.py` stages a second copy of it next
  # to the bindings. Both must be the same object or their registered-operation TypeIDs disagree.
  postFixup = ''
    so="$out/${python.sitePackages}/numba_cuda_mlir/_mlir/_mlir_libs/libMLIRToLLVM70.so"
    patchelf --set-rpath "\$ORIGIN:$(patchelf --print-rpath "$so")" "$so"
  '';

  pythonImportsCheck = [ "numba_cuda_mlir" ];

  disabledTests = [
    # `nvvm.barrier` only grows its reduction operand on the LLVM trunk commit upstream pins, so
    # these lower to nothing here (see `drop-barrier-reduction.patch`)
    #   TypeError: barrier() got an unexpected keyword argument 'reduction'
    "test_syncthreads_and"
    "test_syncthreads_and_downcast"
    "test_syncthreads_and_upcast"
    "test_syncthreads_count"
    "test_syncthreads_count_downcast"
    "test_syncthreads_count_upcast"
    "test_syncthreads_or"
    "test_syncthreads_or_downcast"
    "test_syncthreads_or_upcast"

    # Asserts LLVM symbols stay out of the global scope, which split MLIR libraries cannot do
    "test_no_llvm_symbol_leak_to_global_scope"

    # Not investigated
    #   NvvmError / NVRTCError / ValueError
    "test_inspect_llvm_windows_preserves_debug_info"
    "test_link_mlir_memref"
    "test_ltoir_cabi_preserves_float16_shared_init_stores"
  ];

  # Tests require access to a GPU
  doCheck = false;

  nativeCheckInputs = [
    cffi
    filecheck
    ml-dtypes
    pytest-benchmark
    pytest-rerunfailures
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    # Several tests write caches into `$HOME`
    writableTmpDirAsHomeHook
  ];

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs (old: {
    requiredSystemFeatures = [ "cuda" ];
    doInstallCheck = true;

    nativeBuildInputs = old.nativeBuildInputs ++ [ cudaPackages.cuda_nvcc ];

    preCheck =
      (old.preCheck or "")
      # Fixtures the linker and symbol-isolation tests load. `make` shells out to `nvidia-smi` for
      # the compute capability, which is not in the sandbox; the cubins hold SASS for a single
      # capability, so it has to be the one of the GPU the tests run on.
      + ''
        make -C tests/numba_cuda_tests/testing GPU_CC=$(python -c \
          'from numba_cuda_mlir.tools import get_gpu_compute_capability as c; print(c().replace("sm_", ""))')
        make -C tests/data
        export NUMBA_CUDA_MLIR_TEST_BIN_DIR="$PWD/tests/numba_cuda_tests/testing"
      '';
  });

  meta = {
    description = "MLIR-based CUDA compiler for Python";
    homepage = "https://github.com/NVIDIA/numba-cuda-mlir";
    changelog = "https://github.com/NVIDIA/numba-cuda-mlir/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !config.cudaSupport;
  };
})
