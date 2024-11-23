{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vulkan-memory-allocator";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "VulkanMemoryAllocator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j0Z9OEwQx3RB2cni9eK3gYfwkhOc2ST213b6VseaVzg=";
  };

  patches = [
    # Allows specifying version constraints on the CMake module
    # Remove when version > 3.1.0
    (fetchpatch {
      name = "0001-vulkan-memory-allocator-add-cmake-package-version-file.patch";
      url = "https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/commit/257138b8f5686ae84491a3df9f90a77d5660c3bd.patch";
      hash = "sha256-qbQhIJho/WQqzAwB2zzWgGKx4QK9zKmbaGisbNOV8mg=";
    })
  ];

  # A compiler is only required for the samples. This lets us use stdenvNoCC.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn 'LANGUAGES CXX' 'LANGUAGES NONE'
  '';

  nativeBuildInputs = [
    cmake
  ];

  strictDeps = true;

  meta = {
    description = "Easy to integrate Vulkan memory allocation library";
    homepage = "https://gpuopen.com/vulkan-memory-allocator/";
    changelog = "https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "vulkan-memory-allocator";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
