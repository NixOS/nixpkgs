{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, substituteAll

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
}:

let
  # See FIRMWARE_PACKAGE_VERSION in src/plugins/intel_myriad/myriad_dependencies.cmake
  myriad_firmware_version = "20221129_35";
  myriad_usb_firmware = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/myriad/firmware_usb-ma2x8x_${myriad_firmware_version}.zip";
    hash = "sha256-HKNWbSlMjSafOgrS9WmenbsmeaJKRVssw0NhIwPYZ70=";
  };
  myriad_pcie_firmware = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/myriad/firmware_pcie-ma2x8x_${myriad_firmware_version}.zip";
    hash = "sha256-VmfrAoKQ++ySIgAxWQul+Hd0p7Y4sTF44Nz4RHpO6Mo=";
  };

  # See GNA_VERSION in cmake/dependencies.cmake
  gna_version = "03.00.00.1910";
  gna = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/gna/gna_${gna_version}.zip";
    hash = "sha256-iU3bwK40WfBFE7hTsMq8MokN1Oo3IooCK2oyEBvbt/g=";
  };

  tbbbind_version = "2_5";
  tbbbind = fetchurl {
    url = "https://download.01.org/opencv/master/openvinotoolkit/thirdparty/linux/tbbbind_${tbbbind_version}_static_lin_v2.tgz";
    hash = "sha256-hl54lMWEAiM8rw0bKIBW4OarK/fJ0AydxgVhxIS8kPQ=";
  };
in

stdenv.mkDerivation rec {
  pname = "openvino";
  version = "2022.3.0";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-Ie58zTNatiYZZQJ8kJh/+HlSetQjhAtf2Us83z1jGv4=";
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
  ];

  patches = [
    (substituteAll {
      src = ./cmake.patch;
      inherit (lib) version;
    })
  ];

  postPatch = ''
    mkdir -p temp/vpu/firmware/{pcie,usb}-ma2x8x
    pushd temp/vpu/firmware
    bsdtar -xf ${myriad_pcie_firmware} -C pcie-ma2x8x
    echo "${myriad_pcie_firmware.url}" > pcie-ma2x8x/ie_dependency.info
    bsdtar -xf ${myriad_usb_firmware} -C usb-ma2x8x
    echo "${myriad_usb_firmware.url}" > usb-ma2x8x/ie_dependency.info
    popd

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
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libngraph_backend.so"
  ];

  buildInputs = [
    libusb1
    libxml2
    opencv
    protobuf
    pugixml
    tbb
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
    broken = stdenv.isDarwin; # Cannot find macos sdk
    maintainers = with maintainers; [ tfmoraes ];
  };
}
