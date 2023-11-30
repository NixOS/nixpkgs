{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, substituteAll
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

# runtime
, libusb1
, libxml2
, opencv
, protobuf
, pugixml
, tbb
, cudaPackages
}:

let
  # See GNA_VERSION in cmake/dependencies.cmake
  gna_version = "03.05.00.1906";
  gna = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/gna/gna_${gna_version}.zip";
    hash = "sha256-SlvobZwCaw4Qr6wqV/x8mddisw49UGq7OjOA+8/icm4=";
  };

  tbbbind_version = "2_5";
  tbbbind = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/tbbbind_${tbbbind_version}_static_lin_v3.tgz";
    hash = "sha256-053rJiwGmBteLS48WT6fyb5izk/rkd1OZI6SdTZZprM=";
  };
in

stdenv.mkDerivation rec {
  pname = "openvino";
  version = "2023.0.0";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-z88SgAZ0UX9X7BhBA7/NU/UhVLltb6ANKolruU8YiZQ=";
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
    pkg-config
    (python.withPackages (ps: with ps; [
      cython
      pybind11
      setuptools
    ]))
    shellcheck
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  patches = [
    (substituteAll {
      src = ./cmake.patch;
      inherit (lib) version;
    })
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
    "-DCMAKE_PREFIX_PATH:PATH=${placeholder "out"}"
    "-DCMAKE_MODULE_PATH:PATH=${placeholder "out"}/lib/cmake"
    "-DENABLE_LTO:BOOL=ON"
    # protobuf
    "-DENABLE_SYSTEM_PROTOBUF:BOOL=OFF"
    "-DProtobuf_LIBRARIES=${protobuf}/lib/libprotobuf${stdenv.hostPlatform.extensions.sharedLibrary}"
    # tbb
    "-DENABLE_SYSTEM_TBB:BOOL=ON"
    # opencv
    "-DENABLE_OPENCV:BOOL=ON"
    "-DOpenCV_DIR=${opencv}/lib/cmake/opencv4/"
    # pugixml
    "-DENABLE_SYSTEM_PUGIXML:BOOL=ON"
    # onednn
    "-DENABLE_ONEDNN_FOR_GPU:BOOL=OFF"
    # intel gna
    "-DENABLE_INTEL_GNA:BOOL=ON"
    # python
    "-DENABLE_PYTHON:BOOL=ON"
    # tests
    "-DENABLE_CPPLINT:BOOL=OFF"
    "-DBUILD_TESTING:BOOL=OFF"
    "-DENABLE_SAMPLES:BOOL=OFF"
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isAarch64 "-Wno-narrowing";

  autoPatchelfIgnoreMissingDeps = [
    "libngraph_backend.so"
  ];

  buildInputs = [
    libusb1
    libxml2
    opencv.cxxdev
    protobuf
    pugixml
    tbb
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  enableParallelBuilding = true;

  postInstall = ''
    pushd $out/python/python${lib.versions.majorMinor python.version}
    mkdir -p $python
    mv ./* $python/
    popd
    rm -r $out/python
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
