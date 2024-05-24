{ lib
, gcc12Stdenv
, fetchFromGitHub
, fetchurl
, cudaSupport ? opencv.cudaSupport or false

# build
, addOpenGLRunpath
, autoPatchelfHook
, cmake
, git
, libarchive
, patchelf
, pkg-config
, python3Packages
, shellcheck

# runtime
, flatbuffers
, level-zero
, libusb1
, libxml2
, ocl-icd
, opencv
, protobuf
, pugixml
, snappy
, tbb
, cudaPackages
}:

let
  inherit (lib)
    cmakeBool
  ;

  stdenv = gcc12Stdenv;

  tbbbind_version = "2_5";
  tbbbind = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/tbbbind_${tbbbind_version}_static_lin_v4.tgz";
    hash = "sha256-Tr8wJGUweV8Gb7lhbmcHxrF756ZdKdNRi1eKdp3VTuo=";
  };

  python = python3Packages.python.withPackages (ps: with ps; [
    cython
    pybind11
    setuptools
    sphinx
    wheel
  ]);

in

stdenv.mkDerivation rec {
  pname = "openvino";
  version = "2024.1.0";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-OOSxXpLjmhOgKvrSO6SmY7xLhJSzGXT8w/Y4FnfwTqU=";
  };

  outputs = [
    "out"
    "python"
  ];

  nativeBuildInputs = [
    addOpenGLRunpath
    autoPatchelfHook
    cmake
    git
    libarchive
    patchelf
    pkg-config
    python
    shellcheck
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  postPatch = ''
    mkdir -p temp/tbbbind_${tbbbind_version}
    pushd temp/tbbbind_${tbbbind_version}
    bsdtar -xf ${tbbbind}
    echo "${tbbbind.url}" > ie_dependency.info
    popd
  '';

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-Wno-dev"
    "-DCMAKE_MODULE_PATH:PATH=${placeholder "out"}/lib/cmake"
    "-DCMAKE_PREFIX_PATH:PATH=${placeholder "out"}"
    "-DOpenCV_DIR=${opencv}/lib/cmake/opencv4/"
    "-DProtobuf_LIBRARIES=${protobuf}/lib/libprotobuf${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DPython_EXECUTABLE=${python.interpreter}"

    (cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (cmakeBool "NCC_SYLE" false)
    (cmakeBool "BUILD_TESTING" false)
    (cmakeBool "ENABLE_CPPLINT" false)
    (cmakeBool "ENABLE_TESTING" false)
    (cmakeBool "ENABLE_SAMPLES" false)

    # features
    (cmakeBool "ENABLE_INTEL_CPU" true)
    (cmakeBool "ENABLE_JS" false)
    (cmakeBool "ENABLE_LTO" true)
    (cmakeBool "ENABLE_ONEDNN_FOR_GPU" false)
    (cmakeBool "ENABLE_OPENCV" true)
    (cmakeBool "ENABLE_PYTHON" true)

    # system libs
    (cmakeBool "ENABLE_SYSTEM_FLATBUFFERS" true)
    (cmakeBool "ENABLE_SYSTEM_OPENCL" true)
    (cmakeBool "ENABLE_SYSTEM_PROTOBUF" false)
    (cmakeBool "ENABLE_SYSTEM_PUGIXML" true)
    (cmakeBool "ENABLE_SYSTEM_SNAPPY" true)
    (cmakeBool "ENABLE_SYSTEM_TBB" true)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isAarch64 "-Wno-narrowing";

  autoPatchelfIgnoreMissingDeps = [
    "libngraph_backend.so"
  ];

  buildInputs = [
    flatbuffers
    level-zero
    libusb1
    libxml2
    ocl-icd
    opencv.cxxdev
    pugixml
    snappy
    tbb
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $python
    mv $out/python/* $python/
    rmdir $out/python
  '';

  postFixup = ''
    # Link to OpenCL
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"
    done
  '';

  meta = with lib; {
    description = "OpenVINO™ Toolkit repository";
    longDescription = ''
      This toolkit allows developers to deploy pre-trained deep learning models through a high-level C++ Inference Engine API integrated with application logic.

      This open source version includes several components: namely Model Optimizer, nGraph and Inference Engine, as well as CPU, GPU, MYRIAD,
      multi device and heterogeneous plugins to accelerate deep learning inferencing on Intel® CPUs and Intel® Processor Graphics.
      It supports pre-trained models from the Open Model Zoo, along with 100+ open source and public models in popular formats such as Caffe*, TensorFlow*, MXNet* and ONNX*.
    '';
    homepage = "https://docs.openvinotoolkit.org/";
    license = with licenses; [ asl20 ];
    platforms = platforms.all;
    broken = (stdenv.isLinux && stdenv.isAarch64) # requires scons, then fails with *** Source directory cannot be under variant directory.
      || stdenv.isDarwin; # Cannot find macos sdk
    maintainers = with maintainers; [ tfmoraes ];
  };
}
