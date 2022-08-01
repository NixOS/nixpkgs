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
  version = "20220721";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = pname;
    rev = version;
    sha256 = "sha256-35OwvYYZtfugvujWl6bL8p8HU+z1kQsvnJ+aQOgO8V8=";
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
    "-DNCNN_SYSTEM_GLSLANG=1"
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
