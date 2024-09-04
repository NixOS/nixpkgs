{ lib
, stdenvNoCC
, fetchFromGitHub
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
