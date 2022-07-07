{ lib
, addOpenGLRunpath
, autoPatchelfHook
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, git
, protobuf
, tbb
, opencv
, unzip
, shellcheck
, srcOnly
, python
, enablePython ? false
}:

let

  onnx_src = srcOnly {
    name = "onnx-patched";
    src = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx";
      rev = "v1.8.1";
      sha256 = "+1zNnZ4lAyVYRptfk0PV7koIX9FqcfD1Ah33qj/G2rA=";
    };
    patches = [
      # Fix build with protobuf 3.18+
      # Remove with onnx 1.9 release
      (fetchpatch {
        url = "https://github.com/onnx/onnx/commit/d3bc82770474761571f950347560d62a35d519d7.patch";
        sha256 = "0vdsrklkzhdjaj8wdsl4icn93q3961g8dx35zvff0nhpr08wjb7y";
      })
    ];
  };

in
stdenv.mkDerivation rec {
  pname = "openvino";
  version = "2021.2";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    rev = version;
    sha256 = "pv4WTfY1U5GbA9Yj07UOLQifvVH3oDfWptxxYW5IwVQ=";
    fetchSubmodules = true;
  };

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DNGRAPH_USE_SYSTEM_PROTOBUF:BOOL=ON"
    "-DFETCHCONTENT_FULLY_DISCONNECTED:BOOL=ON"
    "-DFETCHCONTENT_SOURCE_DIR_EXT_ONNX:STRING=${onnx_src}"
    "-DENABLE_VPU:BOOL=OFF"
    "-DTBB_DIR:STRING=${tbb}"
    "-DENABLE_OPENCV:BOOL=ON"
    "-DOPENCV:STRING=${opencv}"
    "-DENABLE_GNA:BOOL=OFF"
    "-DENABLE_SPEECH_DEMO:BOOL=OFF"
    "-DBUILD_TESTING:BOOL=OFF"
    "-DENABLE_CLDNN_TESTS:BOOL=OFF"
    "-DNGRAPH_INTERPRETER_ENABLE:BOOL=ON"
    "-DNGRAPH_TEST_UTIL_ENABLE:BOOL=OFF"
    "-DNGRAPH_UNIT_TEST_ENABLE:BOOL=OFF"
    "-DENABLE_SAMPLES:BOOL=OFF"
    "-DENABLE_CPPLINT:BOOL=OFF"
  ] ++ lib.optional enablePython [
    "-DENABLE_PYTHON:BOOL=ON"
  ];

  preConfigure = ''
    # To make install openvino inside /lib instead of /python
    substituteInPlace inference-engine/ie_bridges/python/CMakeLists.txt \
      --replace 'DESTINATION python/''${PYTHON_VERSION}/openvino' 'DESTINATION lib/''${PYTHON_VERSION}/site-packages/openvino' \
      --replace 'DESTINATION python/''${PYTHON_VERSION}' 'DESTINATION lib/''${PYTHON_VERSION}/site-packages/openvino'
    substituteInPlace inference-engine/ie_bridges/python/src/openvino/inference_engine/CMakeLists.txt \
      --replace 'python/''${PYTHON_VERSION}/openvino/inference_engine' 'lib/''${PYTHON_VERSION}/site-packages/openvino/inference_engine'

    # Used to download OpenCV based on Linux Distro and make it use system OpenCV
    substituteInPlace inference-engine/cmake/dependencies.cmake \
        --replace 'include(linux_name)' ' ' \
        --replace 'if (ENABLE_OPENCV)' 'if (ENABLE_OPENCV AND NOT DEFINED OPENCV)'

    cmakeDir=$PWD
    mkdir ../build
    cd ../build
  '';

  autoPatchelfIgnoreMissingDeps = [ "libngraph_backend.so" ];

  nativeBuildInputs = [
    cmake
    autoPatchelfHook
    addOpenGLRunpath
    unzip
  ];

  buildInputs = [
    git
    protobuf
    opencv
    python
    tbb
    shellcheck
  ] ++ lib.optional enablePython (with python.pkgs; [
    cython
    pybind11
  ]);

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
    broken = stdenv.isDarwin; # Cannot find macos sdk
    maintainers = with maintainers; [ tfmoraes ];
  };
}
