{ lib, stdenv, fetchFromGitHub, cmake, gcc12, vulkan-headers, vulkan-loader }:

stdenv.mkDerivation rec {
  pname = "VulkanMemoryAllocator";
  version = "3.0.1";

  nativeBuildInputs = [
    cmake
    gcc12
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "VulkanMemoryAllocator";
    rev = "v${version}";
    hash = "sha256-urUebQaPTgCECmm4Espri1HqYGy0ueAqTBu/VSiX/8I=";
  };

  meta = with lib; {
    description = "Easy to integrate Vulkan memory allocation library.";
    homepage    = "https://gpuopen.com/vulkan-memory-allocator/";
    platforms   = platforms.unix ++ platforms.windows;
    license     = licenses.mit;
    maintainers = [ maintainers.djburgess ];
  };
}
