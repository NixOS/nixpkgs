{ stdenv, lib, fetchFromGitHub, buildPythonPackage, python,
  cudaSupport ? false, cudatoolkit, cudnn, nccl, magma,
  mklDnnSupport ? true, useSystemNccl ? true,
  MPISupport ? false, mpi,
  buildDocs ? false,
  cudaArchList ? null,

  # Native build inputs
  cmake, util-linux, linkFarm, symlinkJoin, which, pybind11,

  # Build inputs
  numactl,

  # Propagated build inputs
  dataclasses, numpy, pyyaml, cffi, click, typing-extensions,

  # Unit tests
  hypothesis, psutil,

  # virtual pkg that consistently instantiates blas across nixpkgs
  # See https://github.com/NixOS/nixpkgs/pull/83888
  blas,

  # ninja (https://ninja-build.org) must be available to run C++ extensions tests,
  ninja,

  # dependencies for torch.utils.tensorboard
  pillow, six, future, tensorflow-tensorboard, protobuf,

  isPy3k, pythonOlder }:

# assert that everything needed for cuda is present and that the correct cuda versions are used
assert !cudaSupport || (let majorIs = lib.versions.major cudatoolkit.version;
                        in majorIs == "9" || majorIs == "10" || majorIs == "11");

# confirm that cudatoolkits are sync'd across dependencies
assert !(MPISupport && cudaSupport) || mpi.cudatoolkit == cudatoolkit;
assert !cudaSupport || magma.cudatoolkit == cudatoolkit;

let
  setBool = v: if v then "1" else "0";
  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    # nccl is here purely for semantic grouping it could be moved to nativeBuildInputs
    paths = [ cudatoolkit.out cudatoolkit.lib nccl.dev nccl.out ];
  };

  # Give an explicit list of supported architectures for the build, See:
  # - pytorch bug report: https://github.com/pytorch/pytorch/issues/23573
  # - pytorch-1.2.0 build on nixpks: https://github.com/NixOS/nixpkgs/pull/65041
  #
  # This list was selected by omitting the TORCH_CUDA_ARCH_LIST parameter,
  # observing the fallback option (which selected all architectures known
  # from cudatoolkit_10_0, pytorch-1.2, and python-3.6), and doing a binary
  # searching to find offending architectures.
  #
  # NOTE: Because of sandboxing, this derivation can't auto-detect the hardware's
  # cuda architecture, so there is also now a problem around new architectures
  # not being supported until explicitly added to this derivation.
  #
  # FIXME: CMake is throwing the following warning on python-1.2:
  #
  # ```
  # CMake Warning at cmake/public/utils.cmake:172 (message):
  #   In the future we will require one to explicitly pass TORCH_CUDA_ARCH_LIST
  #   to cmake instead of implicitly setting it as an env variable.  This will
  #   become a FATAL_ERROR in future version of pytorch.
  # ```
  # If this is causing problems for your build, this derivation may have to strip
  # away the standard `buildPythonPackage` and use the
  # [*Adjust Build Options*](https://github.com/pytorch/pytorch/tree/v1.2.0#adjust-build-options-optional)
  # instructions. This will also add more flexibility around configurations
  # (allowing FBGEMM to be built in pytorch-1.1), and may future proof this
  # derivation.
  brokenArchs = [ "3.0" ]; # this variable is only used as documentation.

  cudaCapabilities = rec {
    cuda9 = [
      "3.5"
      "5.0"
      "5.2"
      "6.0"
      "6.1"
      "7.0"
      "7.0+PTX"  # I am getting a "undefined architecture compute_75" on cuda 9
                 # which leads me to believe this is the final cuda-9-compatible architecture.
    ];

    cuda10 = cuda9 ++ [
      "7.5"
      "7.5+PTX"  # < most recent architecture as of cudatoolkit_10_0 and pytorch-1.2.0
    ];

    cuda11 = cuda10 ++ [
      "8.0"
      "8.0+PTX"  # < CUDA toolkit 11.0
      "8.6"
      "8.6+PTX"  # < CUDA toolkit 11.1
    ];
  };
  final_cudaArchList =
    if !cudaSupport || cudaArchList != null
    then cudaArchList
    else cudaCapabilities."cuda${lib.versions.major cudatoolkit.version}";

  # Normally libcuda.so.1 is provided at runtime by nvidia-x11 via
  # LD_LIBRARY_PATH=/run/opengl-driver/lib.  We only use the stub
  # libcuda.so from cudatoolkit for running tests, so that we don’t have
  # to recompile pytorch on every update to nvidia-x11 or the kernel.
  cudaStub = linkFarm "cuda-stub" [{
    name = "libcuda.so.1";
    path = "${cudatoolkit}/lib/stubs/libcuda.so";
  }];
  cudaStubEnv = lib.optionalString cudaSupport
    "LD_LIBRARY_PATH=${cudaStub}\${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH ";

in buildPythonPackage rec {
  pname = "pytorch";
  # Don't forget to update pytorch-bin to the same version.
  version = "1.10.2";

  disabled = !isPy3k;

  outputs = [
    "out"   # output standard python package
    "dev"   # output libtorch headers
    "lib"   # output libtorch libraries
  ];

  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-QcvoJqpZJXPSc9HLCJHetrp/hMESuC5kYl90d7Id0ZU=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # pthreadpool added support for Grand Central Dispatch in April
    # 2020. However, this relies on functionality (DISPATCH_APPLY_AUTO)
    # that is available starting with macOS 10.13. However, our current
    # base is 10.12. Until we upgrade, we can fall back on the older
    # pthread support.
    ./pthreadpool-disable-gcd.diff
  ];

  # The dataclasses module is included with Python >= 3.7. This should
  # be fixed with the next PyTorch release.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'dataclasses'" "'dataclasses; python_version < \"3.7\"'"
  '';

  preConfigure = lib.optionalString cudaSupport ''
    export TORCH_CUDA_ARCH_LIST="${lib.strings.concatStringsSep ";" final_cudaArchList}"
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '' + lib.optionalString (cudaSupport && cudnn != null) ''
    export CUDNN_INCLUDE_DIR=${cudnn}/include
  '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

  BUILD_NAMEDTENSOR = setBool true;
  BUILD_DOCS = setBool buildDocs;

  # We only do an imports check, so do not build tests either.
  BUILD_TEST = setBool false;

  # Unlike MKL, oneDNN (née MKLDNN) is FOSS, so we enable support for
  # it by default. PyTorch currently uses its own vendored version
  # of oneDNN through Intel iDeep.
  USE_MKLDNN = setBool mklDnnSupport;
  USE_MKLDNN_CBLAS = setBool mklDnnSupport;

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    ${python.interpreter} setup.py build --cmake-only
    ${cmake}/bin/cmake build
  '';

  preFixup = ''
    function join_by { local IFS="$1"; shift; echo "$*"; }
    function strip2 {
      IFS=':'
      read -ra RP <<< $(patchelf --print-rpath $1)
      IFS=' '
      RP_NEW=$(join_by : ''${RP[@]:2})
      patchelf --set-rpath \$ORIGIN:''${RP_NEW} "$1"
    }
    for f in $(find ''${out} -name 'libcaffe2*.so')
    do
      strip2 $f
    done
  '';

  # Override the (weirdly) wrong version set by default. See
  # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
  # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
  PYTORCH_BUILD_VERSION = version;
  PYTORCH_BUILD_NUMBER = 0;

  USE_SYSTEM_NCCL=setBool useSystemNccl;                  # don't build pytorch's third_party NCCL

  # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
  # (upstream seems to have fixed this in the wrong place?)
  # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
  # https://github.com/pytorch/pytorch/issues/22346
  #
  # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
  # https://github.com/pytorch/pytorch/blob/v1.2.0/setup.py#L17
  NIX_CFLAGS_COMPILE = lib.optionals (blas.implementation == "mkl") [ "-Wno-error=array-bounds" ];

  nativeBuildInputs = [
    cmake
    util-linux
    which
    ninja
    pybind11
  ] ++ lib.optionals cudaSupport [ cudatoolkit_joined ];

  buildInputs = [ blas blas.provider ]
    ++ lib.optionals cudaSupport [ cudnn magma nccl ]
    ++ lib.optionals stdenv.isLinux [ numactl ];

  propagatedBuildInputs = [
    cffi
    click
    numpy
    pyyaml
    typing-extensions
    # the following are required for tensorboard support
    pillow six future tensorflow-tensorboard protobuf
  ] ++ lib.optionals MPISupport [ mpi ]
    ++ lib.optionals (pythonOlder "3.7") [ dataclasses ];

  checkInputs = [ hypothesis ninja psutil ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;
  pythonImportsCheck = [
    "torch"
  ];

  checkPhase = with lib.versions; with lib.strings; concatStringsSep " " [
    cudaStubEnv
    "${python.interpreter} test/run_test.py"
    "--exclude"
    (concatStringsSep " " [
      "utils" # utils requires git, which is not allowed in the check phase

      # "dataloader" # psutils correctly finds and triggers multiprocessing, but is too sandboxed to run -- resulting in numerous errors
      # ^^^^^^^^^^^^ NOTE: while test_dataloader does return errors, these are acceptable errors and do not interfere with the build

      # tensorboard has acceptable failures for pytorch 1.3.x due to dependencies on tensorboard-plugins
      (optionalString (majorMinor version == "1.3" ) "tensorboard")
    ])
  ];
  postInstall = ''
    mkdir $dev
    cp -r $out/${python.sitePackages}/torch/include $dev/include
    cp -r $out/${python.sitePackages}/torch/share   $dev/share

    # Fix up library paths for split outputs
    substituteInPlace \
      $dev/share/cmake/Torch/TorchConfig.cmake \
      --replace \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

    substituteInPlace \
      $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
      --replace \''${_IMPORT_PREFIX}/lib "$lib/lib"

    mkdir $lib
    cp -r $out/${python.sitePackages}/torch/lib     $lib/lib
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    for f in $(ls $lib/lib/*.dylib); do
        install_name_tool -id $lib/lib/$(basename $f) $f || true
    done

    install_name_tool -change @rpath/libshm.dylib $lib/lib/libshm.dylib $lib/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libtorch_python.dylib

    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libtorch.dylib

    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libcaffe2_observers.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libcaffe2_observers.dylib

    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libcaffe2_module_test_dynamic.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libcaffe2_module_test_dynamic.dylib

    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libcaffe2_detectron_ops.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libcaffe2_detectron_ops.dylib

    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libshm.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libshm.dylib
  '';

  # Builds in 2+h with 2 cores, and ~15m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit cudaSupport;
    cudaArchList = final_cudaArchList;
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
  };

  meta = with lib; {
    description = "Open source, prototype-to-production deep learning platform";
    homepage    = "https://pytorch.org/";
    license     = licenses.bsd3;
    platforms   = with platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with maintainers; [ teh thoughtpolice tscholak ]; # tscholak esp. for darwin-related builds
    # error: use of undeclared identifier 'noU'; did you mean 'no'?
    broken = stdenv.isDarwin;
  };
}
