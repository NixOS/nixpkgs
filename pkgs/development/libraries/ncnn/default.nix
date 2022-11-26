{ lib
, stdenv
, fetchFromGitHub
, cmake
, vulkan-headers
, vulkan-loader
, glslang
, opencv
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "ncnn";
  version = "20220729";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = pname;
    rev = "b4ba207c18d3103d6df890c0e3a97b469b196b26";
    sha256 = "0wTwBD1wfHb9ggCTYXV+Z4rGZKSB582GYCp9vNvOeQI=";
    fetchSubmodules = true;
  };

  patches = [
    ./cmakelists.patch
  ];

  cmakeFlags = [
    "-DNCNN_CMAKE_VERBOSE=1" # Only for debugging the build
    "-DNCNN_SHARED_LIB=1"
    "-DNCNN_ENABLE_LTO=1"
    "-DNCNN_VULKAN=1"
    "-DNCNN_BUILD_EXAMPLES=0"
    "-DNCNN_BUILD_TOOLS=0"
    "-DNCNN_SYSTEM_GLSLANG=0"
    "-DNCNN_PYTHON=0" # Should be an attribute

    "-DGLSLANG_TARGET_DIR=${glslang}/lib/cmake"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ vulkan-headers vulkan-loader glslang opencv protobuf ];

  meta = with lib; {
    description = "ncnn is a high-performance neural network inference framework optimized for the mobile platform";
    homepage = "https://github.com/Tencent/ncnn";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tilcreator ];
  };
}
