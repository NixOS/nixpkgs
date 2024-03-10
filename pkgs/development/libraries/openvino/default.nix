{ lib
, gcc12Stdenv
, fetchFromGitHub
, fetchpatch2
, fetchurl
, cudaSupport ? opencv.cudaSupport or false

# build
, addOpenGLRunpath
, autoPatchelfHook
, cmake
, git
, libarchive
, pkg-config
, python
, shellcheck
, sphinx

# runtime
, flatbuffers
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

  # See GNA_VERSION in cmake/dependencies.cmake
  gna_version = "03.05.00.2116";
  gna = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/gna/gna_${gna_version}.zip";
    hash = "sha256-lgNQVncCvaFydqxMBg11JPt8587XhQBL2GHIH/K/4sU=";
  };

  tbbbind_version = "2_5";
  tbbbind = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/tbbbind_${tbbbind_version}_static_lin_v4.tgz";
    hash = "sha256-Tr8wJGUweV8Gb7lhbmcHxrF756ZdKdNRi1eKdp3VTuo=";
  };
in

stdenv.mkDerivation rec {
  pname = "openvino";
  version = "2023.3.0";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-dXlQhar5gz+1iLmDYXUY0jZKh4rJ+khRpoZQphJXfcU=";
  };

  patches = [
    (fetchpatch2 {
      name = "enable-js-toggle.patch";
      url = "https://github.com/openvinotoolkit/openvino/commit/0a8f1383826d949c497fe3d05fef9ad2b662fa7e.patch";
      hash = "sha256-mQYunouPo3tRlD5Yp4EUth324ccNnVX8zmjPHvJBYKw=";
    })
  ];

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
    pkg-config
    (python.withPackages (ps: with ps; [
      cython
      pybind11
      setuptools
    ]))
    shellcheck
    sphinx
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  postPatch = ''
    mkdir -p temp/gna_${gna_version}
    pushd temp/
    bsdtar -xf ${gna}
    autoPatchelf gna_${gna_version}
    echo "${gna.url}" > gna_${gna_version}/ie_dependency.info
    popd

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

    (cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (cmakeBool "NCC_SYLE" false)
    (cmakeBool "BUILD_TESTING" false)
    (cmakeBool "ENABLE_CPPLINT" false)
    (cmakeBool "ENABLE_TESTING" false)
    (cmakeBool "ENABLE_SAMPLES" false)

    # features
    (cmakeBool "ENABLE_INTEL_CPU" true)
    (cmakeBool "ENABLE_INTEL_GNA" true)
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
